require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

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