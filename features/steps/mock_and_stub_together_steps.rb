Given /^you have built something simple that both mocks and stubs$/ do
  # She's gotta be strong to fight them, coz she's taken lots of vitamins
end

When /^you are interested in some more mocking$/ do
  # Oh Yoshimi, they don't believe me
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