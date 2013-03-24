# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name    = "acts_as_activity"
  s.version = "0.0.1"
  s.date    = "2013-03-21"
  s.summary = "Rails plugin to add activities to activity feed"
  s.authors = ["Anthony Byram"]
  s.email   = "anthony@namelessnotion.com"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('mongoid')
  s.add_dependency('mysql2')
  s.add_dependency('rails', '>= 3.2.13')
end
