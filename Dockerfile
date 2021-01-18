FROM ruby:2.7.2

# リポジトリを更新後依存モジュールをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       nodejs \
                       imagemagick \
                       vim

RUN mkdir /short_diary_docker

ENV APP_ROOT /short_diary_docker

WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . $APP_ROOT

RUN mkdir -p tmp/sockets
