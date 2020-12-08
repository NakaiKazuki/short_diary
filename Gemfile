source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gem "rails", "~> 6.0.3", ">= 6.0.3.4"
gem "mysql2"
gem "puma"
gem "sassc-rails"
gem "webpacker"
gem "turbolinks"
gem "jbuilder"
gem "bootsnap", require: false
gem "bcrypt"
gem "rails-i18n"
gem "devise"
gem "devise-i18n"
gem "kaminari"
gem "kaminari-bootstrap"
gem "aws-sdk-s3", require: false
gem "mini_magick"
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap'
gem 'image_processing', '~> 1.2'

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
end

group :test do
  gem "capybara"
  gem "capybara-email"
  gem "webdrivers"
  gem 'database_cleaner'
end
