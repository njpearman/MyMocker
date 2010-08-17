module KoanProgress
  def add_a_test_pass
    @success_count ||= 0
    @success_count += 1
  end

  def current_progress
    @success_count ||= 0
    (@success_count / 21.0) * 100
  end
end

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

class KoanWorld
  def self.populate world
    world.After('@koan') do |scenario|
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

    world.AfterStep('@koan') {|scenario| add_a_test_pass }
    world.World(KoanExpectations)
    world.World(KoanProgress)
  end
end
