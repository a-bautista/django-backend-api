# Base Image

FROM python:3.6

# create the directories for the apps you have added
RUN mkdir /app /core

# set the working directory
WORKDIR /app

# Add the current directories for each app you have added
ADD . /app/
Add . /core/

# set default environment variables
ENV PYTHONUNBUFFERED 1
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive 

# set project environment variables
# grab these via Python's os.environ
# these are 100% optional here
ENV PORT=8888

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata \
        python3-setuptools \
        python3-pip \
        python3-dev \
        python3-venv \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install the postgres dependency
# RUN apt-get update && apt-get install -y software-properties-common postgresql-client

# install environment dependencies
RUN pip3 install --upgrade pip 
RUN pip3 install pipenv

# Install project dependencies
RUN pipenv install --skip-lock --system --dev

# Create a user that runs our container
# -D means to create a user that only runs applications but this is only available in the alpine images
# RUN adduser -D user
RUN adduser --disabled-password --gecos '' user

#switch to the User instead of letting the root user to run it
USER user

# Expose your docker image with the name of your django app
# EXPOSE can have any number because this number will be mapped to your browser.
EXPOSE 8888
# src.app indicates the root level of your folder
CMD gunicorn src.app.wsgi:application --bind 0.0.0.0:$PORT

