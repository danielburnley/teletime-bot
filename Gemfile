# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "redis"
gem 'discordrb', github: 'shardlab/discordrb', branch: 'main'
gem "pry"
gem "dotenv"

group "test" do
  gem "rspec"
  gem "timecop"
end

