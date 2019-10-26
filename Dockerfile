FROM python:3.8-slim

USER root

RUN groupadd -g 1002 gitgroup; useradd -u 1000 -G gitgroup goblin

RUN apt-get update && apt-get upgrade && apt-get -y install build-essential git

COPY . /app

WORKDIR /app

RUN pip install -r requirements_dev.txt

RUN chown -R goblin:goblin /app

USER goblin

RUN git config --global user.email "your_email@example.com"
RUN git config --global user.name "your_email"
