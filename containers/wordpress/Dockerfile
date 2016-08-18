FROM wordpress:apache

RUN apt-get update \
  && apt-get install -y ssmtp \
  && rm -rf /var/lib/apt/lists/*
