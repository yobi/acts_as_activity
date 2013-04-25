require 'rubygems'
require 'optparse'
require 'yaml'
require 'erb'

require 'bundler'
Bundler.setup
Bundler.require :default, :development, :test
require 'mongoid'
Combustion.initialize! :active_record
require File.expand_path('../../lib/acts_as_activity', __FILE__)
root = File.expand_path("#{File.dirname(__FILE__)}/..")

  RestCore::Config.load(
    RestCore::Facebook,
    "#{root}/spec/internal/config/rest-core.yml",
    'test',
    'facebook')
load("#{root}/spec/models.rb")
Mongoid.load!("#{root}/spec/internal/config/mongoid.yml")

require 'irb'
require 'irb/completion'

IRB.start
