require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir["test/*_test.rb"]
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "solid_state"
    gem.summary = %Q{Stateful Ruby objects}
    gem.description = %Q{Add simple states to your classes with different functionality across states.}
    gem.email = "jasongroelofs@gmail.com"
    gem.homepage = "http://github.com/jasonroelofs/solid_state"
    gem.authors = ["Jason Roelofs"]
    gem.add_development_dependency "test-spec"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
