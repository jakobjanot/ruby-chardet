require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'wwtd/tasks'

Rake::TestTask.new(:default) do |t|
  t.test_files = FileList['test/*_test.rb']
end
