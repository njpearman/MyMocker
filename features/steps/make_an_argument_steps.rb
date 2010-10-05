Given /^you are pretty darn good at this shizzle$/ do
  # Those evil natured robots, they're programmed to destory us
end

When /^you have been bored by the triviality of the previous koans$/ do
  # She's disciplined her body
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