# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

gem 'pg', '~> 1.5.6'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'

gem 'bootsnap', require: false
gem 'devise', github: 'heartcombo/devise'
gem 'faraday'
gem 'rack-cors'
gem 'rswag'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'database_cleaner'
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'rubocop'
  gem 'simplecov'
  gem 'webmock'
end

group :development do
  # gem "spring"
end
