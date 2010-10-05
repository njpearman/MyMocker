Given /^the file for the mocker exists$/ do
  sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'my_mock.rb')
  File.exists?(sample_solution_path).should be_true, koan_fail_message("Please create lib/my_mock.rb to get things under way.")
end

When /^MyMock can check if any method has been called$/ do
  MyMock.instance_methods.include?('called?').should be_true, koan_fail_message("called? is not defined as a method on MyMock.","method names can end with a question mark in Ruby.")
end

When /^the method that you want to check is given$/ do
  begin
    MyMock.new.called? :a_method
  rescue NotCalled
  rescue Exception
    fail koan_fail_message("called? needs to be able to accept a method name as a parameter.")
  end
end

Then /^it should tell you that a method has not been called, if you ask$/ do
  message = <<MESSAGE
called? should have raised a NotCalled error, as the tested method name was not invoked on
MyMock....
MESSAGE
  tip = <<TIP
NotCalled has already been defined for you, and you can raise errors using
           raise(YourException.new)"
TIP
  expect_not_called_error(message, tip) do
    @my_mock.called?(:jump)
  end
end

Then /^it should not bork when a no\-argument method is missing$/ do
  message = "method_missing thinks that it should raise NoMethodError for a non-existent method..  :("
  tip = <<TIP
method_missing(method_name, *args) is a method defined on all objects.  Try 
           overriding it.
TIP
  begin
    @my_mock.method_missing :not_mocked
  rescue NoMethodError
    fail koan_fail_message(message, tip)
  end
end

Then /^it should still bork when a method with one argument is missing$/ do
  message = <<MESSAGE
method_missing did not raise a NoMethodError when trying to call with the arguments
(:not_a_real_method, 'first_argument', 'second_argument')
MESSAGE

  tip = <<TIP
First, the parameter *args is an array of arbitrary lenth.
           Second, you can delegate to the object implementation of method_missing by calling
           'super' (You don't even need to explicitly pass the arguments through to super!)
TIP
  begin
    @my_mock.method_missing :not_a_real_method, 'first_argument', 'second_argument'
    fail koan_fail_message(message, tip)
  rescue NoMethodError
  rescue
    fail koan_fail_message(message, tip)
  end
end

Then /^it should return nil from missing_method when no expectations have been set on a method$/ do
  MyMock.new.mock_method.should be_nil
end

Then /^it should not complain when asked if a method has been called and the method has been invoked$/ do
  message = "A NotCalled error should not be raised; the method was invoked on the mock instance!"
  tip = <<TIP
@variable_name is used to declare instance variables.  Use that to let called? know
           that a missing method was called on the mock.
TIP
  @my_mock.mock_method
  expect_no_not_called_error(message, tip) do
    @my_mock.called?(:mock_method)
  end
end

Then /^it should store all of the methods that have been called$/ do
  message = "A NotCalled error should not have been raised for first_method.  first_method was called on the\nmock just before second_method was."
  tip = <<TIP
You are tracking the last method called on the mock, but need to be tracking *every*
           method called on the mock
TIP

  @my_mock.first_method
  @my_mock.second_method

  begin
    @my_mock.called?(:second_method)
  rescue NotCalled
  end

  expect_no_not_called_error(message, tip) do
    @my_mock.called?(:first_method)
  end
end

Then /^it should only indicate that a particular method has been called$/ do
  message = <<MESSAGE
You asked whether different_method was called; it was not, but particular_method was.
MESSAGE
  tip = <<TIP
Try recording the name of each method that is caught in method_missing so that it
           can be used by called?.
TIP
  @my_mock.particular_method
  expect_not_called_error(message, tip) do
    @my_mock.called?(:different_method)
  end
end

Then /^it should track method calls within individual mock instances$/ do
  my_mock = MyMock.new
  my_mock.instance_method
  another_mock = MyMock.new
  another_mock.different_method
  expect_not_called_error("instance_method was called on one instance of MyMock, but not another instance.", "Method calls should only be tracked as instance variables.") do
    another_mock.called?(:instance_method)
  end
  expect_no_not_called_error("A MyMock instance seems to have lost track of a method that was called on it...", "Why has creating a new instance of MyMock wiped out the methods called on a previous\n           instance?") do
    my_mock.called?(:instance_method)
  end
end

Then /^it should return the number of times that a method has been invoked from called\?$/ do
  tip = <<TIP
If you are tracking every method call made on the mock, can you count the calls for
           a particular method name?
TIP

  3.times { @my_mock.three_times }
  result = @my_mock.called?(:three_times)

  message = <<MESSAGE
called? should be returning the number of times that the method was called on the mock;
'three_times' was called 3 times, not #{result.nil?? 'nil' : result} times"
MESSAGE

  result.should equal(3), koan_fail_message(message, tip)
end

Then /^it should return the correct call count for two different methods$/ do
  4.times { @my_mock.flick }
  5.times { @my_mock.flack }
  first_result = @my_mock.called?(:flick)
  second_result = @my_mock.called?(:flack)
  first_result.should equal(4), "flick was called four times, not #{first_result.nil?? 'nil' : first_result} times.  flack was also called five."
  second_result.should equal(5), "flack was called five times, not #{second_result.nil?? 'nil' : second_result} times.  flick was also called four times."
end