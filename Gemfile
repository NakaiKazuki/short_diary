source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'bcrypt'
gem 'bootsnap', require: false
gem 'bootstrap'
gem 'devise'
gem 'devise-i18n'
gem 'image_processing', '~> 1.2'
gem 'jbuilder'
gem 'jquery-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'mini_magick'
gem 'mysql2'
gem 'puma'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'rails-i18n'
gem 'sassc-rails'
gem 'turbolinks'
gem 'uglifier'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'rspec_junit_formatter'
  gem 'webdrivers'
end

group :production do
  gem 'aws-sdk-s3', require: false
end
