require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

module Spec
  module Example
    module ExampleGroupMethods
      def koan behaves_like, for_stage, &the_test
        it behaves_like do
          if NextSpec.run? for_stage
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
  class << self
    def next_stage
      @stage += 1
    end
    def run? stage
      @stage ||= 1
      @stage >= stage
    end
    def current
      @stage ||= 1
    end
  end
end

puts "*** Current stage: #{NextSpec.current}"

describe "Getting up and running" do
  before(:each) do
    @my_mock = MyMock.new if defined? MyMock
  end

  koan "should be able to find the Ruby file", 1 do
    sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'my_mock.rb')
    File.exists?(sample_solution_path).should be_true, "Please create lib/my_mock.rb to get things under way."
  end

  koan "should be defined as a class!!", 2 do
    puts "Checking is defined."
    defined?(MyMock).should be_true, "MyMock hasn't been defined as a class!"
  end

  koan "should tell you that a method wasn't called, if you ask", 3 do
    begin
      @my_mock.called?(:not_called)
      fail "You're not there yet; Method was not called, but NotCalled(method_name) exception was not raised...."
    rescue NotCalled
      # all good
    rescue Exception => e
      # not so good
      fail "You're not there yet; #{e.message}"
    end
  end

  koan "should not bork when a no-argument method is missing", 4 do
    begin
      @my_mock.method_missing :not_mocked
    rescue NoMethodError
      fail "You're not there yet; method_missing thinks it should raise NoMethodError..  :("
    end
  end

  koan "should still bork when a method with arguments is missing", 5 do
    begin
      @my_mock.method_missing :not_mocked, 1, 2, 3
      raise Exception.new
    rescue NoMethodError
    rescue
      fail "You're not there yet; method_missing did not raise a NoMethodError when trying to call with the arguments ':not_mocked,1,2,3'"
    end
  end

  koan "should only return nil from missing_method", 6 do
    @my_mock.mock_method.should be_nil
  end
end
