# The Dockerfile is used to build our image, which contains a mini 
# Linux Operating System with all the dependencies needed to run our project.

# Dockerfile is for building a lightweight Python 3.9-based container
# Sets up a virtual environment, installs dependencies, and configures
# a non-root user to run a Django application securely on port 8000.

FROM python:3.9-alpine3.13
LABEL maintainer="jessie"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user