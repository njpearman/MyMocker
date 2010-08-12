require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

describe "First things first: The koan"do
  koan "should be able to find the mymock.rb file", 1 do
    sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'my_mock.rb')
    File.exists?(sample_solution_path).should be_true, "Please create lib/my_mock.rb to get things under way."
  end

  koan "should be able to load the MyMock class", 2 do
    defined?(MyMock).should be_true, "MyMock hasn't been defined as a class!"
  end
end

describe "The first steps: MyMock instance" do
  before(:each) do
    @my_mock = MyMock.new
  end

  koan "should tell you that a method hasn't been called on it, if you ask", 3 do
    begin
      @my_mock.called?(:jump)
      fail "'jump' was not called on the mock, but NotCalled exception was not raised by called?...."
    rescue NotCalled
      # all good
    end
  end

  koan "should not bork when when a no-argument method is missing", 4 do
    begin
      @my_mock.method_missing :not_mocked
    rescue NoMethodError
      fail "method_missing thinks it should raise NoMethodError..  :("
    end
  end

  koan "should still bork when a method with arguments is missing", 5 do
    begin
      @my_mock.method_missing :not_mocked, 1, 2, 3
      raise Exception.new
    rescue NoMethodError
    rescue
      fail "method_missing did not raise a NoMethodError when trying to call with the arguments ':not_mocked,1,2,3'"
    end
  end

  koan "should only return nil from missing_method", 6 do
    @my_mock.mock_method.should be_nil
  end
end if defined? MyMock

describe "mocking a parameter-less method call: MyMock instance" do
  before(:each) do
    @my_mock = MyMock.new
  end

  koan "should not complain when asked if a method has been called and the method has been invoked", 7 do
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

  koan "should only indicate that a particular method has been called", 1 do
    @my_mock.another_method
    begin
      @my_mock.called?(:mock_method)
      fail "You asked whether mock_method was called; it was not, but another_method was."
    rescue NotCalled
      # as expected
    end
  end
  
  koan "should track method calls within individual mock instances", 9 do
    @my_mock.mock_method
    another_mock = MyMock.new
    begin
      another_mock.called?(:mock_method)
      fail "mock_method was only called on one instance of MyMock."
    rescue NotCalled
    end
  end
end if defined? MyMock

describe "counting the number of method calls: MyMock instance" do
  before(:each) do
    @my_mock = MyMock.new
  end

  koan "should return the number of times that a method has been invoked from called?", 19 do
    @my_mock.mock_method
    @my_mock.mock_method
    @my_mock.mock_method
    result = @my_mock.called?(:mock_method)
    result.should equal(3), "mock_method was called 3 times, not #{result.nil?? 'nil' : result} times"
  end

  koan "should return the correct call count for two different methods", 19 do
    @my_mock.mock_method
    @my_mock.mock_method
    @my_mock.mock_method
    @my_mock.another_method
    @my_mock.another_method
    first_result = @my_mock.called?(:mock_method)
    second_result = @my_mock.called?(:another_method)
    first_result.should equal(3), "mock_method was called 3 times, not #{first_result.nil?? 'nil' : first_result} times.  another_method was also called twice."
    second_result.should equal(2), "another_method was called twice, not #{second_result.nil?? 'nil' : second_result} times.  mock_method was also called three times."
  end
end if defined? MyMock

describe "mocking the return value for a parameter-less method call: MyMock instance" do
  before(:each) do
    @my_mock = MyMock.new
  end

  koan "should let you set an expected return value", 10 do
    @my_mock.returns(1)
  end

  koan "should let you specify a method name that a return value will be used for", 11 do
    @my_mock.from(:mock_method)
  end

  koan "should let you set up return values in the style of a 'fluent' thing", 12 do
    begin
      @my_mock.returns(1).from(:mock_method)
    rescue
      fail "MyMock can't chain a from() call to a return() call e.g. my_mock.return(101).from('my_method')."
    end
  end

  koan "should return the expected string from a mock method call", 13 do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    result = @my_mock.mock_method
    result.should be_eql("You're mockin' now!"), "Mock method should have returned \"You're mockin' now!\" but returned #{result}."
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
    @my_mock.another_method.should be_nil, "only mock_method was set up to return [You're mockin' now!], but another_method is also returning this."
  end

  koan "should only define the result on the specific mock instance", 16 do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    another_mock = MyMock.new
    another_mock.mock_method.should be_nil
    @my_mock.mock_method.should == "You're mockin' now!"
  end

  koan "should still track that a method with a defined return value was called", 1 do
    @my_mock.returns("You're mockin now!").from(:mock_method)
    @my_mock.mock_method
    begin
      @my_mock.called? :mock_method
    rescue NotCalled
      fail "NotCalled should not have been raised, as mock_method was both defined with a return value and called."
    end
  end

  koan "should still track the number of times that a method with a defined return value was called", 1 do
    @my_mock.returns("You're mockin now!").from(:mock_method)
    @my_mock.mock_method
    @my_mock.mock_method
    @my_mock.mock_method
    count = @my_mock.called? :mock_method
    count.should equal(3), "mock_method has a return value defined and was called 3 times not #{count.nil?? 'nil' : count} times."
  end
end if defined? MyMock

describe "mocking return values for several parameterless methods: MyMock instance" do
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
end if defined? MyMock

describe "testing that your new mocking class works: MyMock instance" do
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