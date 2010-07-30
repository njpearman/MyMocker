require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

describe "mocking a parameterless method a number of times" do
  before(:each) do
    @my_mock = MyMock.new
  end

  it "should return the number of times that a method has been called from called?" do
    @my_mock.mock_method
    @my_mock.mock_method
    @my_mock.mock_method
    result = @my_mock.called?(:mock_method)
    result.should equal(3), "You're not there yet; mock_method was called 3 times, not #{result.nil?? 'nil' : result} times"
  end
end