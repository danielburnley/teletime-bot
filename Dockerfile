FROM ruby:3.0-alpine

WORKDIR /app
COPY Gemfile ./
COPY Gemfile.lock ./
RUN apk --no-cache add alpine-sdk && bundle install && apk del alpine-sdk
ADD . /app

CMD bundle exec ruby run_bot.rb
