require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  require 'bundler'
  Bundler.setup
  Bundler.require :default, :development, :test
  require 'mongoid'
  require 'acts_as_activity'
  Combustion.initialize! :active_record

  root = File.expand_path File.dirname(__FILE__)
  Dir["#{root}/support/**/*.rb"].each { |file| require file }
  Mongoid.load!("#{root}/internal/config/mongoid.yml")
  RestCore::Config.load(
    RestCore::Facebook,
    "#{root}/internal/config/rest-core.yml",
    'test',
    'facebook')
  load(File.dirname(__FILE__) + '/models.rb')
end

Spork.each_run do
  # This code will be run each time you run your specs.

  RSpec.configure do |config|
    FactoryGirl.find_definitions
    config.include FactoryGirl::Syntax::Methods
    config.filter_run :wip => nil
    config.run_all_when_everything_filtered = true
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner[:mongoid].strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

