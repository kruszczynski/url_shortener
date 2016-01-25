FROM ruby:2.3.0-slim

# deps
RUN apt-get update -qq && apt-get install -y build-essential

# set bundle data volume path
ENV BUNDLE_PATH=/bundle

# set app home
ENV APP_HOME=/usr/src/app
WORKDIR $APP_HOME
