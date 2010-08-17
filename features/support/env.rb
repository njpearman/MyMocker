sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'my_mock.rb')
require sample_solution_path if File.exists? sample_solution_path
require File.join(File.expand_path(File.dirname(__FILE__)), 'koan_world.rb')

class Hammer
  def hit thing
    thing.hit
  end
end

class Blender
  def blend thing
    "It blends!" if thing.blends?
  end
end

class Toaster
  def add food
    @food = food
    return self
  end

  def press_switch
    @food.toast
  end
end

class ToasterMalfunction < Exception; end

# This is an exception used by MyMock.  Moved it out of the test bay if you dare
# use this stuff.
class NotCalled < Exception; end

KoanWorld.populate(self)