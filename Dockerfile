FROM python:3.8-slim

USER root

RUN apt-get update && apt-get upgrade && apt-get -y install build-essential git

RUN git config --global user.email "your_email@example.com"
RUN git config --global user.name "your_email"

COPY . /app

WORKDIR /app

RUN pip install -r requirements_dev.txt
