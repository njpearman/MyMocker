current_path = File.expand_path(File.dirname(__FILE__))
sample_solution_path = File.join(current_path, '..', '..', 'lib', 'my_mock.rb')
examples_path = File.join(current_path, '..', '..', 'lib', 'examples')
Dir.foreach(examples_path) do |file|
  require File.join(examples_path, file) if file =~ /\.rb$/
end
require sample_solution_path if File.exists? sample_solution_path
require File.join(current_path, 'koan_world.rb')

# This is an exception used by MyMock.  Move it out of the test bay if you dare
# use this stuff.
class NotCalled < Exception; end

# decorate the cucumber world with the Koan landscape
KoanWorld.populate(self)