FROM ruby:2.5.3-slim

RUN apt-get update && \
    apt-get -y install nodejs build-essential libsqlite3-dev && \
    apt-get clean
RUN gem install rails

WORKDIR /
RUN rails new app

WORKDIR /app
RUN bundle install --deployment --without development,test --path vendor/bundle
RUN bin/rails g controller env env

ADD routes.rb /app/config/routes.rb
ADD env_controller.rb /app/app/controllers/env_controller.rb
ADD env.html.erb /app/app/views/env/env.html.erb

EXPOSE 80
# USER root # TODO make it ARG

ENTRYPOINT ["/app/bin/rails"]
CMD ["server", "-p", "80", "-b", "0.0.0.0"]
