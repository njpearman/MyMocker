module Spec
  module Example
    module ExampleGroupMethods
      def koan behaves_like, for_stage, &the_test
        it behaves_like do
          if NextSpec.run?
            instance_eval &the_test
            NextSpec.next_stage
          else
            pending
          end
        end
      end
    end
  end
end

class NextSpec
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
      @next ||= NextSpec.new
      @next.run?
    end
  end
end