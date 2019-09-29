FROM ruby:2.6.4

RUN bundle config --global frozen 1

RUN mkdir /app
RUN mkdir -p /app/lib/knowledge
WORKDIR /app

RUN gem update --system
RUN gem install bundler -v "~> 2.0" --no-doc

COPY lib/knowledge/version.rb ./lib/knowledge
COPY knowledge.gemspec Gemfile Gemfile.lock ./

RUN bundle install

COPY . .