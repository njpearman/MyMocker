Given /^the file for the mocker exists$/ do
  sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'my_mock.rb')
  File.exists?(sample_solution_path).should be_true, "Please create lib/my_mock.rb to get things under way."
end

Given /^the koan is complete$/ do
  # Her name is Yoshimi, she's a black belt in karate
end

Given /^you have already built something that mocks$/ do
  # but you won't let those Robots eat me
end

Given /^you have built something simple that both mocks and stubs$/ do
  # She's gotta be strong to fight them, coz she's taken lots of vitamins
end

Given /^you are pretty darn good at this shizzle$/ do
  # Those evil natured robots, they're programmed to destory us
end

When /^a new MyMock instance is created$/ do
  defined?(MyMock).should be_true, "MyMock hasn't been defined as a class.  Put it in the my_mock.rb file."
  @my_mock = MyMock.new
end

When /^MyMock can check if any method has been called$/ do
  MyMock.instance_methods.include?('called?').should be_true, "called? is not defined as a method on MyMock.\n   -> Tip:  method names can end with a question mark in Ruby."
end

When /^the method that you want to check is given$/ do
  begin
    MyMock.new.called? :a_method
  rescue NotCalled
  rescue Exception
    fail "called? needs to be able to accept a method name as a parameter."
  end
end

When /^you are interested in some more mocking$/ do
  # Oh Yoshimi, they don't believe me
end


When /^you have been bored by the triviality of the previous koans$/ do
  # She's disciplined her body
end

Then /^it should tell you that a method has not been called on it, if you ask$/ do
  failure_message = "called? should have raised a NotCalled error, as the tested method name was not invoked on MyMock...."
  expect_not_called_error(failure_message) { @my_mock.called?(:jump) }
end

Then /^it should not bork when when a no\-argument method is missing$/ do
  begin
    @my_mock.method_missing :not_mocked
  rescue NoMethodError
    fail "method_missing thinks that it should raise NoMethodError for a non-existent method..  :(\n (Tip: method_missing is a method defined on all objects.  Try overriding it.)"
  end
end

Then /^it should still bork when a method with arguments is missing$/ do
  begin
    @my_mock.method_missing :not_mocked, 1, 2, 3
    raise Exception.new
  rescue NoMethodError
  rescue
    fail "method_missing did not raise a NoMethodError when trying to call with the arguments ':not_mocked, 1, 2, 3'\n   -> Tip: you can delegate to the super class implementation of a method using 'super', and no arguments are necessary\n"
  end

end

Then /^it should return nil from missing_method when no expectations have been set on a method$/ do
  MyMock.new.mock_method.should be_nil
end

Then /^it should not complain when asked if a method has been called and the method has been invoked$/ do
  @my_mock.mock_method
  failure_message = "A NotCalled error should not be raised; mock_method was called on the mock!"
  expect_no_not_called_error(failure_message) { @my_mock.called?(:mock_method) }
end

Then /^it should not complain if two different methods have been called$/ do
  @my_mock.mock_method
  @my_mock.another_method

  failure_message = "Should not have raised a NotCalled error...  mock_method was called on the mock!\n"
  expect_no_not_called_error(failure_message) { @my_mock.called?(:mock_method) }

  failure_message = "Should not have raised a NotCalled error...  another_method was called on the mock!\n"
  expect_no_not_called_error(failure_message) { @my_mock.called?(:another_method) }
end

Then /^it should only indicate that a particular method has been called$/ do
  @my_mock.particular_method
  failure_message = "You asked whether different_method was called; it was not, but particular_method was."
  expect_not_called_error(failure_message) { @my_mock.called?(:different_method) }
end

Then /^it should track method calls within individual mock instances$/ do
  @my_mock.mock_method
  another_mock = MyMock.new
  failure_message = "mock_method was called on one instance of MyMock, but not another instance."
  expect_not_called_error(failure_message) { another_mock.called?(:mock_method) }
end

Then /^it should return the number of times that a method has been invoked from called\?$/ do
  3.times { @my_mock.three_times }
  result = @my_mock.called?(:three_times)
  result.should equal(3), "three_times was called 3 times, not #{result.nil?? 'nil' : result} times"
end

Then /^it should return the correct call count for two different methods$/ do
  4.times { @my_mock.flick }
  5.times { @my_mock.flack }
  first_result = @my_mock.called?(:flick)
  second_result = @my_mock.called?(:flack)
  first_result.should equal(4), "flick was called four times, not #{first_result.nil?? 'nil' : first_result} times.  flack was also called twice."
  second_result.should equal(5), "flack was called five times, not #{second_result.nil?? 'nil' : second_result} times.  flick was also called three times."
end

Then /^it should let you set an expected return value$/ do
  @my_mock.returns(1)
end

Then /^it should let you specify a method name that a return value will be used for$/ do
  @my_mock.from(:mock_method)
end

Then /^it should let you set up return values in the style of a fluent thing$/ do
  begin
    @my_mock.returns(1).from(:mock_method)
  rescue
    fail "MyMock can't chain a from() call to a return() call e.g. my_mock.return(101).from('my_method')."
  end
end

Then /^it should return the expected string from a mock method call$/ do
  expected_result = "You're mockin' now!"
  @my_mock.returns(expected_result).from(:mock_method)
  result = @my_mock.mock_method
  result.should be_eql("You're mockin' now!"), "The mock method should have returned \"You're mockin' now!\" but returned #{result}.\n   -> clue 2\n"
end

Then /^it should be able to set any object as the return value from a mock method call$/ do
  expected_result = Object.new
  @my_mock.returns(expected_result).from(:mock_method)
  result = @my_mock.mock_method
  result.should equal(expected_result), "Mock method should have returned the expected Object reference, but returned #{result} as a #{result.class} instead."
end

Then /^it should only set the return value for one method expectation$/ do
  expected_result = "You're mockin' now!"
  @my_mock.returns(expected_result).from :with_result
  @my_mock.from :without_result
  @my_mock.without_result.should be_nil, "only with_result was set up to return [You're mockin' now!], but without_result is also returning this."
end

Then /^it should only define the result on the specific mock instance$/ do
  expected_result = "You're mockin' now!"
  @my_mock.returns(expected_result).from(:mock_method)
  another_mock = MyMock.new
  another_mock.mock_method.should be_nil
  @my_mock.mock_method.should == "You're mockin' now!"
end

Then /^it should still track that a method with a defined return value was called$/ do
  @my_mock.returns("You're mockin now!").from(:once_with_result)
  @my_mock.once_with_result
  failure_message = "NotCalled should not have been raised, as once_with_result was both defined with a return value and called."
  expect_no_not_called_error(failure_message) { @my_mock.called? :once_with_result }
end

Then /^it should still track the number of times that a method with a defined return value was called$/ do
  @my_mock.returns("You're mockin now!").from(:three_times_with_result)
  3.times { @my_mock.three_times_with_result }
  count = @my_mock.called? :three_times_with_result
  count.should equal(3), "three_times_with_result has a return value defined and was called 3 times not #{count.nil?? 'nil' : count} times."
end

Then /^it should always return the expected return value$/ do
  expected_result = "You're mockin' now!"
  @my_mock.returns(expected_result).from(:mock_method)
  @my_mock.mock_method.should == "You're mockin' now!"
  @my_mock.mock_method.should == "You're mockin' now!"
end

Then /^it should let you set expected return values on several methods$/ do
  expected_mock_method_result = "You're mockin' now!"
  @my_mock.returns(expected_mock_method_result).from(:mock_method)

  expected_other_method_result = "Mocking more!"
  @my_mock.returns(expected_other_method_result).from(:other_method)

  @my_mock.mock_method.should == "You're mockin' now!"
  @my_mock.other_method.should == "Mocking more!"
end

Then /^it should stub "([^"]*)" as an argument$/ do |the_parameter|
  @my_mock.single_argument(the_parameter)
  expect_no_not_called_error("single_argument was called with '#{the_parameter}'") { @my_mock.called? :single_argument }
end

Then /^it should know when a method has unexpectedly been called with an argument$/ do
  @my_mock.with_an_argument
  expect_not_called_error("with_an_argument was not called with 'smackdown'") do
    begin
      @my_mock.called? :with_an_argument, :with => 'smackdown'
    rescue ArgumentError => e
      fail "called? doesn't seem to be accepting the hash ':with => expected_parameter' as a second argument.\n -> #{e.message}"
    end
  end
end

Then /^it should let you mock a return value with "([^"]*)" as an argument$/ do |the_parameter|
  @my_mock.returns('Back once again').from(:mocked_argument)
  @my_mock.mocked_argument(the_parameter)
  call_count = @my_mock.called?(:mocked_argument, :with => the_parameter)
  call_count.should equal(1), "single_argument was called with '#{the_parameter}, but MyMock doesn't think that it has been."
end

Then /^it should not set that expectation on "([^"]*)"$/ do |the_parameter|
  @my_mock.mocked_argument('giggidy')
  fail_message = "mocked_argument was not called with '#{the_parameter}, but MyMock thinks that it has been..??"
  expect_not_called_error(fail_message) { @my_mock.called?(:mocked_argument, :with => the_parameter) }
end

Then /^it should always return the same value for "([^"]*)"$/ do |the_parameter|
  @my_mock.returns('Back once again').from(:repeat_argument)
  @my_mock.repeat_argument(the_parameter)
  @my_mock.repeat_argument(the_parameter)
  @my_mock.repeat_argument(the_parameter)
  call_count = @my_mock.called?(:repeat_argument, :with => the_parameter)
  call_count.should equal(3), "repeat_argument was called three times with '#{the_parameter}, but MyMock thinks that it has been called #{call_count} times."
end