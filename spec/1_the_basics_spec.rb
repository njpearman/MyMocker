require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

describe "Getting up and running" do
  before(:each) do
    @my_mock = MyMock.new
  end

  it "should be defined as a class!!" do
    defined?(MyMock).should be_true, "MyMock hasn't been defined as a class!"
  end

  it "should tell you that a method wasn't called, if you ask" do
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

  it "should not bork when a no-argument method is missing" do
    begin
      @my_mock.method_missing :not_mocked
    rescue NoMethodError
      fail "You're not there yet; method_missing thinks it should raise NoMethodError..  :("
    end
  end

  it "should still bork when a method with arguments is missing" do
    begin
      @my_mock.method_missing :not_mocked, 1, 2, 3
      raise Exception.new
    rescue NoMethodError
    rescue
      fail "You're not there yet; method_missing did not raise a NoMethodError when trying to call with the arguments ':not_mocked,1,2,3'"
    end
  end

  it "should only return nil from missing_method" do
    @my_mock.mock_method.should be_nil
  end
end