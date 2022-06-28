FROM python:3.8.12-slim
RUN apt-get update -y
RUN apt-get install -y python-dev build-essential

ARG USERID
ENV UID=$USERID

ARG GROUPID
ENV GID=$GROUPID

RUN addgroup --gid $GID analyst
RUN useradd analyst -u$UID -g$GID -d/home/analyst -s/bin/bash

COPY . /install
WORKDIR /install
RUN pip install --upgrade pip
RUN pip install -r requirements.txt


RUN mkdir /home/analyst
RUN chown analyst:analyst -R /home/analyst
WORKDIR /home/analyst

USER analyst

ENTRYPOINT ["jupyter", "notebook", "--ip", "0.0.0.0"]
#CMD ["/bin/bash"]
