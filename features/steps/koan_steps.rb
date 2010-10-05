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
  defined?(MyMock).should be_true, koan_fail_message("MyMock hasn't been defined as a class.  Put it in the my_mock.rb file.")
  @my_mock = MyMock.new
end

When /^you are interested in some more mocking$/ do
  # Oh Yoshimi, they don't believe me
end


When /^you have been bored by the triviality of the previous koans$/ do
  # She's disciplined her body
end

Then /^it should let you set an expected return value$/ do
  if @my_mock.methods.include?('returns')
    begin
      @my_mock.returns(1)
    rescue ArgumentError
      fail "MyMock should define returns() with a parameter that will be the return value."
    end
  else
    fail "MyMock should define returns() with a parameter that will be the return value."
  end
end

Then /^it should let you specify a method name that a return value will be used for$/ do
  if @my_mock.methods.include?('from')
    begin
      @my_mock.from(:the_method)
    rescue ArgumentError
      fail "MyMock should define from() with a parameter that will be the method name returning the value."
    end
  else
    fail "MyMock should define from() with a parameter that will be the method name returning the value."
  end
end

Then /^it should let you set up return values in the style of a fluent thing$/ do
  message = "MyMock can't chain a from() call to a return() call e.g. my_mock.return(101).from('my_method')."
  tip = <<TIP
If you return self from a method, then chaining another call directly off of the method
           is not really breaking the law of demeter.
TIP
  begin
    @my_mock.returns(1).from(:mock_method)
  rescue
    fail koan_fail_message message, tip
  end
end

Then /^it should return the expected string from a mock method call$/ do
  expected_result = "You're stubbin' now!"
  @my_mock.returns(expected_result).from(:mock_method)
  result = @my_mock.mock_method
  fail_message = <<MSG
The mock method should have returned "You're mockin' now!" but returned #{result}.
   -> If "#{expected_result}" has been set as the return value in #return, then
      that value should be returned when the next method is invoked.
MSG
  result.should be_eql("You're stubbin' now!"), fail_message
end

Then /^it should be able to set any object as the return value from a mock method call$/ do
  expected_result = Object.new
  @my_mock.returns(expected_result).from(:mock_method)
  result = @my_mock.mock_method
  result.should equal(expected_result), "Mock method should have returned the expected Object reference, but returned #{result} as a #{result.class} instead."
end

Then /^it should return the value set for a particular method/ do
  first_result = "You're stubbin' now!"
  second_result = "You're stubbin' again!"
  @my_mock.returns(first_result).from :stubbed_first
  @my_mock.returns(second_result).from :stubbed_second
  fail_message = <<MSG
The method first_result was set up to return \"#{first_result}\", but it's returning the result from a method that has been stubbed subsequently.
   -> Tip: Does your stub implementation set the return value for a particular method name, or for all method calls?
MSG
  @my_mock.stubbed_first.should equal(first_result), fail_message
end

Then /^it should only set the return value for one method expectation$/ do
  expected_result = "You're stubbin' now!"
  @my_mock.returns(expected_result).from :with_result
  @my_mock.from :without_result
  fail_message = <<MSG
The method without_result was not stubbed and is returning \"You're stubbin' now!\", which was set previously on the method with_result.
   -> Tip: Does your stub implementation keep hold of a return value, even after it has been used?
MSG
  @my_mock.without_result.should be_nil, fail_message
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
  expect_no_not_called_error("NotCalled should not have been raised, as the method once_with_result has been set up with a return value and also involed on the stub / mock.") do
    @my_mock.called? :once_with_result
  end
end

Then /^it should still track the number of times that a method with a defined return value was called$/ do
  @my_mock.returns("You're mockin now!").from(:three_times_with_result)
  3.times { @my_mock.three_times_with_result }
  count = @my_mock.called? :three_times_with_result
  count.should equal(3), "The method three_times_with_result has a return value defined and was called 3 times not #{count.nil?? 'nil' : count} times."
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
  expect_no_not_called_error("The method single_argument was called with '#{the_parameter}'") { @my_mock.called? :single_argument }
end

Then /^it should let you specify an expected argument$/ do
  begin
    @my_mock.called? :with_an_argument, :with => 'smackdown'
  rescue ArgumentError => e
    fail "called? doesn't seem to be accepting the hash ':with => expected_parameter' as a second method parameter.\n -> #{e.message}"
  rescue NotCalled
  end
end

Then /^it should know whether a method has been called with an argument or not$/ do
  message = "with_an_argument was not called with the parameter 'smackdown', but MyMock thinks that it was..."
  tip = <<TIP
method_missing let's you inspect the arguments that were passed to a method that
           doesn't exist.  This can help you match the expected arguments you pass to called?"
TIP
  @my_mock.with_an_argument
  expect_not_called_error(message, tip) do
    @my_mock.called? :with_an_argument, :with => 'smackdown'
  end
end

Then /^it should let you mock a return value with "([^"]*)" as an argument$/ do |the_parameter|
  @my_mock.returns('Back once again').from(:mocked_argument)
  @my_mock.mocked_argument(the_parameter)
  call_count = @my_mock.called?(:mocked_argument, :with => the_parameter)
  call_count.should equal(1), "The method single_argument was invoked with '#{the_parameter}', but MyMock doesn't think that it has been."
end

Then /^it should not set that expectation on "([^"]*)"$/ do |the_parameter|
  @my_mock.mocked_argument('giggidy')
  fail_message = "The method mocked_argument was not called with '#{the_parameter}, but MyMock thinks that it has been..??"
  expect_not_called_error(fail_message) { @my_mock.called?(:mocked_argument, :with => the_parameter) }
end

Then /^it should always return the same value for "([^"]*)"$/ do |the_parameter|
  @my_mock.returns('Back once again').from(:repeat_argument)
  @my_mock.repeat_argument(the_parameter)
  @my_mock.repeat_argument(the_parameter)
  @my_mock.repeat_argument(the_parameter)
  call_count = @my_mock.called?(:repeat_argument, :with => the_parameter)
  call_count.should equal(3), "The method repeat_argument was called three times with '#{the_parameter}', but MyMock thinks that it has been called #{call_count} times."
end