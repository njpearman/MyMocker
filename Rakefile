require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = 'MyMocker'
  s.version = '0.0.1'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'MyMocker presents a set of koans in Ruby to build your own simple mocking tool.'
  s.description = s.summary
  s.author = ''
  s.email = ''
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "MyMockr Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

#Spec::Rake::SpecTask.new do |t|
#  t.spec_files = FileList['spec/**/*.rb']
#  t.libs << Dir["lib"]
#end

#Spec::Rake::SpecTask.new(:koans) do |t|
#  t.spec_files = FileList['koans/**/*.rb']
#  t.libs << Dir["lib"]
#end

begin
  require 'cucumber/rake/task'

  namespace :cukoan do
    Cucumber::Rake::Task.new(:enlightenment, 'Runs the koan') do |t|
      t.fork = false # You may get faster startup if you set this to false
      t.profile = 'default'
    end

    Cucumber::Rake::Task.new(:examples, 'Run the examples to see whether your mocker works') do |t|
      t.fork = false # You may get faster startup if you set this to false
      t.profile = 'examples'
    end
  end
  desc 'Alias for cukoan:enlightenment'
  task :cukoan => 'cukoan:enlightenment'

  task :default => :cukoan
rescue LoadError
  desc 'cukoan rake task not available (cucumber not installed)'
  task :cukoan do
    abort 'Cukoan rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
