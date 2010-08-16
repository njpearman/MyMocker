sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'my_mock.rb')
require sample_solution_path if File.exists? sample_solution_path

class KoanTracker
  def add_a_test_pass
    @success_count ||= 0
    @success_count += 1
  end

  def current_progress
    @success_count ||= 0
    (@success_count / 21.0) * 100
  end
end

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

module KoanExpectations
  def expect_not_called_error failure_message
    begin
      yield
      fail failure_message
    rescue NotCalled
      # all good
    end
  end

  def expect_no_not_called_error failure_message
    begin
      yield
    rescue NotCalled
      fail failure_message
    end
  end
end

module KoanProgress
  def current_progress
    @koan_tracker ||= KoanTracker.new
    @koan_tracker.current_progress
  end

  def add_a_test_pass
    @koan_tracker ||= KoanTracker.new
    @koan_tracker.add_a_test_pass
  end
end

After('@koan') do |scenario|
  progress = current_progress
  puts "\nKoan progress currently stands at #{("%.2f" % progress)}%"
  if progress == 100
    puts "You are truly enlightened.  Try running rake cukoan:all to see everything fly."
  elsif progress > 48
    puts "You are well on the way to enlightenment.  Try running rake cukoan:all to see more things fly."
  elsif progress > 38
    puts "You are moving towards enlightenment.  Try running rake cukoan:all to see something fly."
  else
    puts "Through hard work and application, you shall achieve enlightenment."
  end
end

AfterStep('@koan') do |scenario|
  add_a_test_pass
end

World(KoanExpectations)
World(KoanProgress)
