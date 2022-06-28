#  Python Datascience Notebook

This repository contains a Dockerfile and python requirements for building a lightweight pyhton data Jupyter notebook deployable as a docker container.

##  Running

Run the container, ensuring you:

  *  map the home folder to the internal `/home/analyst` container folder.  (The internal folder cannot be changed, as jupyter will launch there)
  *  map the host port to the internal container port

For example, the following will start jupyter datascience notebook and map the local host folder `/home/myuser/dev/project` to internal folder `/home/analyst`.  


```
docker run -it -v /home/myuser/dev/project/:/home/analyst -p8889:8888 henderso/python-datascience-nb
```

Check the output in the terminal.   It will show the URL and token for connecting to the notebook.

If you want to run the container in the background:

```
docker run -d -v /home/myuser/dev/project/:/home/analyst -p8889:8888 henderso/python-datascience-nb
```

Then use `docker ps` to get the `container_name` and then `docker logs container_name` to see the connection log.

##  Building

You can rebuild the container to meet your needs as follows:


1.  Update `requirements.txt` to contain any libraries you want to add.  See below for more details on how to discover and test these.

2.  Execute the following.  The `build-arg` will ensure the docker container user, `analyst` has the same UID/GID as your host user so you can mount the host directory without drama.

```
docker build --build-arg GROUPID=$(id -g) --build-arg USERID=$(id -u) -t henderso/python-datascience-nb .
```

##  Permissions & Volumes

The container is set to use a non-root user, `analyst`.  If you want to mount a host folder (e.g. `/home/myuser/dev/project` owned by host user `myuser`) while using the container (highly recommended so you can save your work), then that `analyst` user in the container needs to share the UID and GID of the user that owns the host folder (`myuser`).

The pre-built container is built with `user=1000` and `gid=1000`.  So if those don't match your host user's uid and gid (check using the `id` command) then you will need to rerun the build using the command above with will rebuild the container and make the mappings.

## Adding Python Libraries

If you need to add a library temporarily, you can install it inside jupyter.  Just add a new cell and run pip:

```
pip install chucknorris
```

Execute the cell...you should see evidence of install:


```
Defaulting to user installation because normal site-packages is not writeable
Collecting chucknorris
  Downloading chucknorris-2.8-py2.py3-none-any.whl (9.1 kB)
Requirement already satisfied: requests in /usr/local/lib/python3.8/site-packages (from chucknorris) (2.26.0)
Collecting backports.functools-lru-cache
  Downloading backports.functools_lru_cache-1.6.4-py2.py3-none-any.whl (5.9 kB)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.8/site-packages (from requests->chucknorris) (3.3)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/local/lib/python3.8/site-packages (from requests->chucknorris) (1.26.7)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.8/site-packages (from requests->chucknorris) (2021.10.8)
Requirement already satisfied: charset-normalizer~=2.0.0 in /usr/local/lib/python3.8/site-packages (from requests->chucknorris) (2.0.7)
Installing collected packages: backports.functools-lru-cache, chucknorris
Successfully installed backports.functools-lru-cache-1.6.4 chucknorris-2.8
Note: you may need to restart the kernel to use updated packages
```

If you want to add the library permanetly to the image, add a new notebook sell and type:

```
pip freeze
```

Run the cell and then copy the new library entry (e.g. `chucknorris==2.8`) or copy the entire output and place into the `requirements.txt` file in this folder and rebuild the container.

## References

  * [Niels Søholm - Docker permissions](https://medium.com/@nielssj/docker-volumes-and-file-system-permissions-772c1aee23ca)
