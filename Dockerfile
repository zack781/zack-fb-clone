FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client ruby-dev ruby-nokogiri

RUN mkdir /zack-fb-clone
WORKDIR /zack-fb-clone

COPY Gemfile /zack-fb-clone/Gemfile
COPY Gemfile.lock /zack-fb-clone/Gemfile.lock

# COPY database.yml /zack-fb-clone/config/database.yml

RUN gem install nokogiri --platform=ruby
RUN bundle config set force_ruby_platform true 

RUN bundle install

COPY . /zack-fb-clone

EXPOSE 3000

CMD ["bash"]

