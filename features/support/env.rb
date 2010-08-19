sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'my_mock.rb')
require sample_solution_path if File.exists? sample_solution_path
require File.join(File.expand_path(File.dirname(__FILE__)), 'koan_world.rb')

# This is a hammer. A hammer hits things
class Hammer
  def hit thing
    thing.hit
  end
end

# This is a blender.  A blender blends things.
class Blender
  def blend thing
    "It blends!" if thing.blends?
  end
end

# This is a toaster.  A toaster toasts things (but never with champagne)
class Toaster
  def add food
    @food = food
    return self
  end

  def press_switch
    @food.toast
  end
end

# This is an exception used by MyMock.  Moved it out of the test bay if you dare
# use this stuff.
class NotCalled < Exception; end

# populate the cucumber world with the Koan landscape
KoanWorld.populate(self)