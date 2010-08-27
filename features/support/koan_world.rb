class ProgressTracker
  def self.add_a_test_pass
    @success_count ||= 0
    @success_count += 1
  end

  def self.current_progress
    @success_count ||= 0
    (@success_count / 21.0) * 100
  end

  def self.progress_message
    progress = current_progress

    message = "\nKoan progress currently stands at #{("%.2f" % progress)}%\n"
    if progress == 100
      message << "You are truly enlightened.  Try running rake cukoan:all to see everything fly."
    elsif progress > 48
      message << "You are well on the way to enlightenment.  Try running rake cukoan:all to see more things fly."
    elsif progress > 38
      message << "You are moving towards enlightenment.  Try running rake cukoan:all to see something fly."
    else
      message << "Through hard work and application, you shall achieve enlightenment."
    end
    message << "\n\n"
  end
end

module KoanProgress
  @@run_next = true

  def run_next?
    @@run_next
  end

  def stop_koans
    @@run_next = false
  end

  def add_a_test_pass
    ProgressTracker.add_a_test_pass
  end

  def current_progress
    ProgressTracker.current_progress
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
    world.Before('@koan') do |scenario|
      scenario.skip_invoke! unless run_next?
    end
    
    world.After('@koan') do |scenario|
      stop_koans if run_next? && scenario.failed?
    end

    world.AfterStep('@koan') {|scenario| add_a_test_pass }
    world.World(KoanExpectations)
    world.World(KoanProgress)
  end
end
