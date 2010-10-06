sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'my_mock.rb')
examples_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'examples')
Dir.foreach(examples_path) {|file| require File.join(examples_path, file) if file =~ /\.rb$/ }
require sample_solution_path if File.exists? sample_solution_path
require File.join(File.expand_path(File.dirname(__FILE__)), 'koan_world.rb')

# This is an exception used by MyMock.  Moved it out of the test bay if you dare
# use this stuff.
class NotCalled < Exception; end

# populate the cucumber world with the Koan landscape
KoanWorld.populate(self)