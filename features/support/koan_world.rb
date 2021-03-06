class ProgressTracker
  @success_count = 0

  def self.add_a_test_pass
    @success_count += 1
  end

  def self.progress_message
    progress = (@success_count / NumberOfSteps) * 100

    message = "\nKoan progress currently stands at #{("%.2f" % progress)}%\n"
    if @success_count >= NumberOfSteps
      message << "You are truly enlightened.  Try running #{ExampleCommand} to see everything fly."
    elsif @success_count > 13
      message << "You are well on the way to enlightenment.  Try running #{ExampleCommand} to see more things fly."
    elsif @success_count > 10
      message << "You are moving towards enlightenment.  Try running #{ExampleCommand} to see something fly."
    else
      message << "Through hard work and application, you shall achieve enlightenment."
    end
    message << "\n\n"
  end

  private
  ExampleCommand = 'rake cukoan:examples'
  NumberOfSteps = 40.0
end

class FailureMessage
  def initialize message, tip=nil
    @message, @tip = message, tip
  end
  
  def to_s
    return "#{@message}\n   -> Tip: #{@tip}" if @tip
    return @message
  end
end

module KoanProgress
  @@run_next_koan = true

  def run_next_koan?
    @@run_next_koan
  end

  def stop_koans
    @@run_next_koan = false
  end

  def add_a_test_pass
    ProgressTracker.add_a_test_pass
  end
end

module KoanExpectations
  def expect_not_called_error failure_message, tip=nil
    begin
      yield
      fail koan_fail_message(failure_message, tip)
    rescue NotCalled
      # all good
    end
  end

  def expect_no_not_called_error failure_message, tip=nil
    begin
      yield
    rescue NotCalled
      fail koan_fail_message(failure_message, tip)
    end
  end

  def koan_fail_message message, tip=nil
    FailureMessage.new(message, tip).to_s
  end
end

class KoanWorld
  def self.populate world
    world.Before('@koan') {|scenario| scenario.skip_invoke! unless run_next_koan? }
    world.AfterStep('@koan') {|scenario| add_a_test_pass }
    world.After('@koan') {|scenario| stop_koans if(run_next_koan? && scenario.failed?) }

    world.World(KoanExpectations)
    world.World(KoanProgress)
  end
end
