require 'rubygems'
require 'spork'
require 'omniauth'
OmniAuth.config.test_mode = true


Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'sidekiq/testing'

  OmniAuth.config.mock_auth[:github] = {
    'uid' => '1337',
    'provider' => 'github',
    'info' => {
      'name' => 'cesar gomez',
      'nickname' => 'cesargomez89'
    }
  }

  RSpec.configure { |c| c.treat_symbols_as_metadata_keys_with_true_values = true  }
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f  }
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.infer_base_class_for_anonymous_controllers = false
  end

end

Spork.each_run do
end
