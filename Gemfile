source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'autoprefixer-rails'
gem 'bcrypt'
gem 'bootsnap', require: false
gem 'devise'
gem 'devise-i18n'
gem 'fast_blank'
gem 'image_processing'
gem 'jbuilder'
gem 'mini_magick'
gem 'mysql2'
gem 'pagy'
gem 'puma', '< 5'
gem 'rack-attack'
gem 'rails', '~> 6.0.3', '>= 6.0.3.5'
gem 'rails-i18n'
gem 'ransack'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'sassc-rails'
gem 'turbolinks'
gem 'webpacker'

group :development, :test do
  gem 'brakeman', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'bcrypt_pbkdf'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano'
  gem 'capistrano3-puma', '< 5'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-rbenv-vars'
  gem 'ed25519'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'listen'
  gem 'rack-mini-profiler', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'sshkit-sudo'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
end

group :production do
  gem 'aws-sdk-s3', require: false
  gem 'google-analytics-rails'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
