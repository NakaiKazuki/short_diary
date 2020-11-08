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
gem "rails-i18n"
gem "bootstrap"
gem "jquery-rails"
gem "bcrypt"
gem "rails-i18n"
gem 'devise'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

group :development, :test do
  gem "mysql2"
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
  gem "webdrivers"
end
