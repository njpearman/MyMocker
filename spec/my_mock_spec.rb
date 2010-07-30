require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'my_mock')

class Hammer
  def hit thing
    thing.hit
  end
end

class Blender
  def blend thing
    "It blends!" if thing.blends?
  end
end

class Toaster
  def add food
    @food = food
    return self
  end

  def press_switch
    @food.toast
  end
end

class ToasterMalfunction < Exception; end

# This is an exception used by MyMock.  Moved it out of the test bay if you dare
# use this stuff.
class NotCalled < Exception
  def initialize method_name
    super "#{method_name.to_s} was never called."
  end
end

# ooo err, test area
class MyMock
  def initialize
    @method_returns = {}
    @method_calls = []
  end
  def called? method_name
    raise NotCalled.new method_name unless @method_calls.include? method_name
    @method_calls.count {|method| method_name == method }
  end
  def method_missing method_name, *args
    super method_name, *args unless args.empty?
    @method_calls << method_name
    return nil
  end
  def returns return_value
    @return_value = return_value
    self
  end
  def from method_name
    @method_returns[method_name] = @return_value
    @return_value = nil
    self.class.instance_eval do
      define_method(method_name) do
        @method_calls << method_name
        @method_returns[method_name]
      end
    end
  end
end
# aaaah, out of the test area

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

describe "mocking a parameter-less method call" do
  before(:each) do
    @my_mock = MyMock.new
  end

  it "should not complain if a method has been called" do
    @my_mock.mock_method
    begin
      @my_mock.called?(:mock_method)
    rescue NotCalled => e
      fail "Should not have raised a NotCalled error...  mock_method was mocked!\n[#{e.message}]"
    end
  end

  it "should not complain if two different methods have been called" do
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

  it "should track method calls within individual mock instances" do
    @my_mock.mock_method
    another_mock = MyMock.new
    begin
      another_mock.called?(:mock_method)
      fail "You're not there yet; mock_method was only called on one instance of MyMock."
    rescue NotCalled
    end
  end
end

describe "mocking the return value for a parameter-less method call" do
  before(:each) do
    @my_mock = MyMock.new
  end

  it "should let you set an expected return value" do
    begin
      @my_mock.returns(1)
    rescue
      fail "returns(return_value) is not defined on MyMock"
    end
  end

  it "should let you set the method that a return value applies to" do
    begin
      @my_mock.from(:mock_method)
    rescue
      fail "from(method_name) has not been defined on MyMock"
    end
  end

  it "should let you set up return values in the style of a 'fluent' thing" do
    begin
      @my_mock.returns(1).from(:mock_method)
    rescue
      fail "MyMock can't chain returns() to from()."
    end
  end

  it "should return the expected string from a mock method call" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    result = @my_mock.mock_method
    result.should match("You're mockin' now!"), "Mock method should have returned \"You're mockin' now!\" but returned #{result}."
  end

  it "should be able to set any object as the return value from a mock method call" do
    expected_result = Object.new
    @my_mock.returns(expected_result).from(:mock_method)
    result = @my_mock.mock_method
    result.should equal(expected_result), "Mock method should have returned the expected Object reference, but returned #{result} as a #{result.class} instead."
  end

  it "should only set the return value for one method expectation" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from :mock_method
    @my_mock.from :another_method
    @my_mock.another_method.should be_nil, "You're not there yet; only mock_method was set up to return [You're mockin' now!], but another_method is also returning this."
  end

  it "should only define the result on the specific mock instance" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    another_mock = MyMock.new
    another_mock.mock_method.should be_nil
    @my_mock.mock_method.should == "You're mockin' now!"
  end

  it "should always return the expected return value" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    @my_mock.mock_method.should == "You're mockin' now!"
    @my_mock.mock_method.should == "You're mockin' now!"
  end

  it "should let you set expected return values on several methods" do
    expected_mock_method_result = "You're mockin' now!"
    @my_mock.returns(expected_mock_method_result).from(:mock_method)

    expected_other_method_result = "Mocking more!"
    @my_mock.returns(expected_other_method_result).from(:other_method)

    @my_mock.mock_method.should == "You're mockin' now!"
    @my_mock.other_method.should == "Mocking more!"
  end
end

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

describe "testing that your new mocking class works" do
  it "should make a mockery of toasting bread" do
    @slice_of_bread = MyMock.new
    Toaster.new.add(@slice_of_bread).press_switch
    @slice_of_bread.called?(:toast)
  end

  it "should make a mockery of blending toasters" do
    @toaster = MyMock.new
    @toaster.returns(true).from(:blends?)
    Blender.new.blend(@toaster).should == "It blends!"
  end

  it "should make a mockery of hammering in a nail" do
    @nail = MyMock.new
    @hammer = Hammer.new
    3.times { @hammer.hit(@nail) }
    @nail.called?(:hit).should == 3
  end
end
