class NextKoan
  def next_stage
    @run_next = true
  end

  def run?
    @run_next = true unless defined? @run_next
    run = @run_next
    @run_next = false
    return run
  end
  
  class << self
    def next_stage
      @next.next_stage
    end
    def run?
      @next ||= NextKoan.new
      @next.run?
    end
  end
end