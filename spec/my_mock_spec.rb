require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'my_mock')

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
  def should_call method_name
    raise NotCalled.new method_name unless @called == method_name
  end
  def method_missing method_name
    @called = method_name
    return nil
  end
  def returns return_value
    @return_value = return_value
    self
  end
  def from method_name
    self.class.instance_eval { define_method(method_name) {@return_value}} #"def #{method_name}; #{@return_value}; end"
    #(class << self; self; end).instance_eval { define_method(method_name) { @return_value }}
  end
end
# aaaah, out of the test area

describe "mocking a parameter-less method call" do
  before(:each) do
    @my_mock = MyMock.new
  end

  it "should make a mockery of blending toasters" do
    @toaster = MyMock.new
    @toaster.returns(true).from(:blends?)
    Blender.new.blend(@toaster).should == "It blends!"
  end

  it "should make a mockery of toasting bread" do
    @slice_of_bread = MyMock.new
    Toaster.new.add(@slice_of_bread).press_switch
    @slice_of_bread.called?(:toast)
  end

#  it "should track that a method has been called a number of times" do
#    @my_mock.mock_method
#    @my_mock.mock_method
#    @my_mock.mock_method
#    @my_mock.call_count(:mock_method).should == 3
#  end
#
#  it "should allow you to check how many times a method has been called" do
#    begin
#      @my_mock.should_call(:mock_method).should == 0
#    rescue Exception => e
#      #not so good
#      fail "You're not there yet: #{e.message}"
#    end
#  end

  it "should let you set expected return values on several methods" do
    expected_mock_method_result = "You're mockin' now!"
    @my_mock.returns(expected_mock_method_result).from(:mock_method)

    expected_other_method_result = "Mocking more!"
    @my_mock.returns(expected_other_method_result).from(:other_method)

    @my_mock.mock_method.should == "You're mockin' now!"
    @my_mock.other_method.should == "Mocking more!"
  end

  it "should always return the expected return value" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    @my_mock.mock_method.should == "You're mockin' now!"
    @my_mock.mock_method.should == "You're mockin' now!"
  end

  it "should only define the result on the specific mock instance" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    another_mock = MyMock.new
    another_mock.mock_method.should be_nil
    @my_mock.mock_method.should == "You're mockin' now!"
  end

  it "should return the expected value from a mock method call" do
    expected_result = "You're mockin' now!"
    @my_mock.returns(expected_result).from(:mock_method)
    result = @my_mock.mock_method
    result.should match("You're mockin' now!"), "Mock method should have returned \"You're mockin' now!\" but returned #{result}."
  end

  it "should let you set up return values in the style of a 'fluent' thing" do
    begin
      @my_mock.returns(1).from(:mock_method)
    rescue
      fail "MyMock can't chain returns() to from()."
    end
  end

  it "should let you set the method that a return value applies to" do
    begin
      @my_mock.from(:mock_method)
    rescue
      fail "from(method_name) has not been defined on MyMock"
    end
  end

  it "should let you set an expected return value" do
    begin
      @my_mock.returns(1)
    rescue
      fail "returns(return_value) is not defined on MyMock"
    end
  end

  it "should only return nil from missing_method" do
    @my_mock.mock_method.should be_nil
  end

  it "should not complain if a method has been called" do
    @my_mock.mock_method
    begin
      @my_mock.should_call(:mock_method)
    rescue NotCalled => e
      fail "Should not have raised a NotCalled error...  mock_method was mocked!\n[#{e.message}]"
    end
  end

  it "should not bork when a no-argument method is missing" do
    begin
      @my_mock.method_missing :mocked
    rescue NoMethodError
      fail "You're not there yet; method_missing thinks it should raise NoMethodError..  :("
    end
  end

  it "should tell you that a method wasn't called, if you ask" do
    begin
      @my_mock.should_call(:not_called)
      fail "Method was not called, but NotCalled(method_name) exception was not raised...."
    rescue NotCalled
      # all good
    rescue Exception => e
      # not so good
      fail "You're not there yet; #{e.message}"
    end
  end

  it "should be defined as a class!!" do
    defined?(MyMock).should be_true, "MyMock hasn't been defined as a class!"
  end
end