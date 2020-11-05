FROM python:3.7-alpine
MAINTAINER Felix Garcia Lainez

ENV PYTHONUNBUFFERED 1

# Install dependencies
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev

# Install requirements
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# Remove temporal build files
RUN apk del .tmp-build-deps

# Setup directory structure
RUN mkdir /app
WORKDIR /app
COPY ./app/ /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user
