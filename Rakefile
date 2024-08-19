# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: :rubocop

require "rake/testtask"
Rake::TestTask.new do |t|
  t.name = "test" # this is the default
  t.libs << "test" # load the test dir
  t.test_files = Dir["test/*test*.rb"]
  t.verbose = true
end
