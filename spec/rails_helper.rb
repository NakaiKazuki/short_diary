require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'capybara/email/rspec'
# devise追加
# require 'devise'
#---ブラウザテストでメールのテストをするために---
Capybara.server_host = 'webapp'
Capybara.server_port = 3001
#------

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f|
  require f
}

#---コンテナ上でRspec動かすのに必要---
Capybara.register_driver :remote_chrome do |app|
  url = ENV.fetch('SELENIUM_DRIVER_URL')
  caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:chromeOptions' => {
      'args' => [
        'no-sandbox',
        'headless',
        'disable-gpu',
        'window-size=1680,1050'
      ]
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :remote, url: url,
                                      desired_capabilities: caps)
end
#------

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  # ---FactoryBot Devise追加---
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  # ------

  #---RSspecを動かすのに必要---
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
  #------

  #---Database Cleaner設定---
  # データ毎にidが+1になるのが気持ち悪いから導入。
  # テスト全体が始まる前に実行
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  #------

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
