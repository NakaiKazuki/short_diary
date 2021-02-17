FROM ruby:2.7.2

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    imagemagick \
    vim \
    nodejs\
    yarn

RUN apt-get clean

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /short_diary_docker

ENV APP_ROOT /short_diary_docker

WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . $APP_ROOT

RUN yarn install --check-files
RUN yarn webpack --config ./config/webpack/development.js

RUN mkdir -p tmp/sockets
