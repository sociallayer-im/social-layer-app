VERSION 0.6
FROM ruby:3.1.2
WORKDIR /app
ARG IMAGE_VER=1.0.0
ENV RUBYOPT W0

build:
    RUN apt-get update && apt-get install -y postgresql-client libpq-dev nodejs tzdata imagemagick nginx
    COPY Gemfile* ./
    RUN bundle install
    COPY . .
    RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` rails assets:precompile
    COPY ./config/nginx/ /etc/nginx
    RUN mkdir -p /app/tmp/pids/
    CMD ["bash", "-c", "nginx -c /etc/nginx/nginx.conf && rails s -b 0.0.0.0"]
    SAVE IMAGE solas:latest solas:$IMAGE_VER
