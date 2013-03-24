# vim:set filetype=ruby:
guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^spec/models.rb}) { "spec" }
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
end
