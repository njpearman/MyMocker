require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

describe "Getting up and running" do
  before(:each) do
    @my_mock = MyMock.new if defined? MyMock
  end

  koan "should be able to find the Ruby file", 1 do
    sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'my_mock.rb')
    File.exists?(sample_solution_path).should be_true, "Please create lib/my_mock.rb to get things under way."
  end

  koan "should be defined as a class!!", 2 do
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

describe "mocking a parameter-less method call" do
  before(:each) do
    @my_mock = MyMock.new
  end

  koan "should not complain if a method has been called", 7 do
    @my_mock.mock_method
    begin
      @my_mock.called?(:mock_method)
    rescue NotCalled => e
      fail "Should not have raised a NotCalled error...  mock_method was mocked!\n[#{e.message}]"
    end
  end

  koan "should not complain if two different methods have been called", 8 do
    @my_mock.mock_method
    @my_mock.another_method
    begin
      @my_mock.called?(:mock_method)
    rescue NotCalled => e
      fail "Should not have raised a NotCalled error...  mock_method was called on the mock!\n[#{e.message}]"
    end
    begin
      @my_mock.called?(:another_method)
    rescue NotCalled => e
      fail "Should not have raised a NotCalled error...  another_method was called on the mock!\n[#{e.message}]"
    end
  end

  koan "should track method calls within individual mock instances", 9 do
    @my_mock.mock_method
    another_mock = MyMock.new
    begin
      another_mock.called?(:mock_method)
      fail "You're not there yet; mock_method was only called on one instance of MyMock."
    rescue NotCalled
    end
  end
end if defined? MyMock

describe "mocking the return value for a parameter-less method call" do
  before(:each) do
    @my_mock = MyMock.new
  end

  koan "should let you set an expected return value", 10 do
    begin
      @my_mock.returns(1)
    rescue
      fail "returns(return_value) is not defined on MyMock"
    end
  end

  koan "should let you set the method that a return value applies to", 11 do
    begin
      @my_mock.from(:mock_method)
    rescue
      fail "from(method_name) has not been defined on MyMock"
    end
  end

  koan "should let you set up return values in the style of a 'fluent' thing", 12 do
    begin
      @my_mock.returns(1).from(:mock_method)
    rescue
      fail "MyMock can't chain returns() to from()."
    end
  end

  koan "should return the expected string from a mock method call", 13 do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    result = @my_mock.mock_method
    result.should match("You're mockin' now!"), "Mock method should have returned \"You're mockin' now!\" but returned #{result}."
  end

  koan "should be able to set any object as the return value from a mock method call", 14 do
    expected_result = Object.new
    @my_mock.returns(expected_result).from(:mock_method)
    result = @my_mock.mock_method
    result.should equal(expected_result), "Mock method should have returned the expected Object reference, but returned #{result} as a #{result.class} instead."
  end

  koan "should only set the return value for one method expectation", 15 do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from :mock_method
    @my_mock.from :another_method
    @my_mock.another_method.should be_nil, "You're not there yet; only mock_method was set up to return [You're mockin' now!], but another_method is also returning this."
  end

  koan "should only define the result on the specific mock instance", 16 do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    another_mock = MyMock.new
    another_mock.mock_method.should be_nil
    @my_mock.mock_method.should == "You're mockin' now!"
  end
end if defined? MyMock

describe "mocking a parameterless method a number of times" do
  before(:each) do
    @my_mock = MyMock.new
  end

  koan "should always return the expected return value", 17 do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    @my_mock.mock_method.should == "You're mockin' now!"
    @my_mock.mock_method.should == "You're mockin' now!"
  end

  koan "should let you set expected return values on several methods", 18 do
    expected_mock_method_result = "You're mockin' now!"
    @my_mock.returns(expected_mock_method_result).from(:mock_method)

    expected_other_method_result = "Mocking more!"
    @my_mock.returns(expected_other_method_result).from(:other_method)

    @my_mock.mock_method.should == "You're mockin' now!"
    @my_mock.other_method.should == "Mocking more!"
  end

  koan "should return the number of times that a method has been called from called?", 19 do
    @my_mock.mock_method
    @my_mock.mock_method
    @my_mock.mock_method
    result = @my_mock.called?(:mock_method)
    result.should equal(3), "You're not there yet; mock_method was called 3 times, not #{result.nil?? 'nil' : result} times"
  end
end if defined? MyMock

describe "testing that your new mocking class works" do
  koan "should make a mockery of toasting bread", 20 do
    @slice_of_bread = MyMock.new
    Toaster.new.add(@slice_of_bread).press_switch
    @slice_of_bread.called?(:toast)
  end

  koan "should make a mockery of blending toasters", 21 do
    @toaster = MyMock.new
    @toaster.returns(true).from(:blends?)
    Blender.new.blend(@toaster).should == "It blends!"
  end

  koan "should make a mockery of hammering in a nail", 22 do
    @nail = MyMock.new
    @hammer = Hammer.new
    3.times { @hammer.hit(@nail) }
    @nail.called?(:hit).should == 3
  end
end if defined? MyMock