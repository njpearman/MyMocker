require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

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