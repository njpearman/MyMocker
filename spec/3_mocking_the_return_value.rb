require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

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