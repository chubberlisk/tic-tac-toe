FROM ruby:2.6.1

WORKDIR /app
COPY Gemfile ./
COPY Gemfile.lock ./
RUN gem install bundler
RUN bundle install

ADD . /app

CMD ["/app/bin/tic_tac_toe"]
