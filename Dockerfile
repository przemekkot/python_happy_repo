FROM python:3.8-slim

USER root

RUN apt-get update && apt-get upgrade && apt-get -y install build-essential

COPY . /app

WORKDIR /app

RUN pip install -r requirements_dev.txt
