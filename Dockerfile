FROM ubuntu

RUN apt update -y
RUN apt install python3 python3-pip pipenv docker.io -y




# CMD pipenv run uvicorn main:app --host 0.0.0.0 --port 80
# CMD pipenv run python3 ./main.py