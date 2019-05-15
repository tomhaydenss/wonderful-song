FROM ruby:2.6.2-alpine

ENV APP_HOME /app
ENV PAGER busybox more

RUN apk update && apk add build-base linux-headers \
                          postgresql-dev \ 
                          nodejs yarn libcurl \
                          tzdata

RUN mkdir ${APP_HOME}

RUN echo "require('irb/completion')" > ~/.irbrc

WORKDIR ${APP_HOME}

COPY Gemfile Gemfile.lock package.json ./
RUN gem install bundler
RUN bundle

EXPOSE 3000