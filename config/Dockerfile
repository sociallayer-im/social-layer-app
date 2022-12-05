FROM ruby:3.1.2
RUN apt-get update && apt-get install -y postgresql-client libpq-dev nodejs tzdata imagemagick nginx
WORKDIR /app
ENV RUBYOPT W0
COPY Gemfile* ./
RUN bundle install
COPY . .
RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` rails assets:precompile
ADD ./config/nginx/ /etc/nginx
RUN mkdir -p /app/tmp/pids/
EXPOSE 3000
EXPOSE 80
CMD ["bash", "-c", "nginx -c /etc/nginx/nginx.conf && rails s -b 0.0.0.0"]