FROM ubuntu

RUN apt update -y
RUN apt install python3 python3-pip pipenv docker.io -y
RUN usermod -aG docker $USER
RUN docker --version




