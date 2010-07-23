require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'my_mock')

describe "mocking a parameter-less method call" do
  before(:each) do
    @my_mock = MyMock.new
  end

  it "should allow you to check if a method has been called" do
    @my_mock.has_called?(:mock_method).should be_false
  end

  it "should allow you to check how many times a method has been called" do
    @my_mock.call_count(:mock_method).should == 0
  end

  it "should not bork when calling a non existent method" do
    lambda { @my_mock.mock_method }.should_not raise_error NoMethodError
  end

  it "should not bork when a no-argument method is missing" do
    lambda { @my_mock.method_missing :mocked }.should_not raise_error NoMethodError
  end

  it "should return nil for a missing method" do
    @my_mock.mock_method.should be_nil
  end

  it "should track that a method has been called once" do
    @my_mock.mock_method
    @my_mock.has_called?(:mock_method).should be_true
  end

  it "should track that a method has been called a number of times" do
    @my_mock.mock_method
    @my_mock.mock_method
    @my_mock.mock_method
    @my_mock.call_count(:mock_method).should == 3
  end

  it "should let you set an expected return value" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    result = @my_mock.mock_method
    result.should == expected_result
  end

  it "should always return the expected return value" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    @my_mock.mock_method.should == expected_result
    @my_mock.mock_method.should == expected_result
  end

  it "should let you set expected return values on several methods" do
    expected_mock_method_result = "You're mockin' now!"
    @my_mock.returns(expected_mock_method_result).from(:mock_method)

    expected_other_method_result = "Mocking more!"
    @my_mock.returns(expected_other_method_result).from(:other_method)
    
    @my_mock.mock_method.should == expected_mock_method_result
    @my_mock.other_method.should == expected_other_method_result
  end
end