Given /^you have already built something that mocks$/ do
  # but you won't let those Robots eat me
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