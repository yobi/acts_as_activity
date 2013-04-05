# vim:set filetype=ruby:
guard 'spork', rspec_port: 8900, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'rspec', cli: "--drb --drb-port 8900 --color"  do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^spec/models.rb}) { "spec" }
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }
  watch('lib/acts_as_activity.rb') { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
end

