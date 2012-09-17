require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new :spec do |t|
  t.pattern = "spec/lib/**/*_spec.rb"
end
