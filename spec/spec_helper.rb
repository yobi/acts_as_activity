require 'rubygems'
require 'bundler'

Bundler.require :default, :development, :test
require 'mongoid'
require 'acts_as_activity'
require 'acts_as_activity/railtie'

Combustion.initialize! :active_record

root = File.expand_path File.dirname(__FILE__)
Dir["#{root}/support/**/*.rb"].each { |file| require file }

load(File.dirname(__FILE__) + '/models.rb')

RSpec.configure do |config|
  FactoryGirl.find_definitions
  config.include FactoryGirl::Syntax::Methods
  config.filter_run :wip => nil
  config.run_all_when_everything_filtered = true
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
