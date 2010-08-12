Given /^the file for the mocker exists$/ do
  sample_solution_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'my_mock.rb')
  File.exists?(sample_solution_path).should be_true, "Please create lib/my_mock.rb to get things under way."
end

When /^a new MyMock instance is created$/ do
  defined?(MyMock).should be_true, "MyMock hasn't been defined as a class!"
  @my_mock = MyMock.new
end

Then /^it should tell you that a method has not been called on it, if you ask$/ do
  begin
    @my_mock.called?(:jump)
    fail "'jump' was not invoked on the mock, but NotCalled exception was not raised by called?...."
  rescue NotCalled
    # all good
  end
end

Then /^it should not bork when when a no\-argument method is missing$/ do
  begin
    @my_mock.method_missing :not_mocked
  rescue NoMethodError
    fail "method_missing thinks that it should raise NoMethodError for a non-existent method..  :("
  end
end

Then /^it should still bork when a method with arguments is missing$/ do
  begin
    @my_mock.method_missing :not_mocked, 1, 2, 3
    raise Exception.new
  rescue NoMethodError
  rescue
    fail "method_missing did not raise a NoMethodError when trying to call with the arguments ':not_mocked, 1, 2, 3'\n   -> clue 1\n"
  end
end

Then /^it should only return nil from missing_method$/ do
  @my_mock.mock_method.should be_nil
end

Then /^it should not complain when asked if a method has been called and the method has been invoked$/ do
  @my_mock.mock_method
  begin
    @my_mock.called?(:mock_method)
  rescue NotCalled => e
    fail "A NotCalled error should not be raised; mock_method was called on the mock!"
  end
end

Then /^it should not complain if two different methods have been called$/ do
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

Then /^it should only indicate that a particular method has been called$/ do
  @my_mock.particular_method
  begin
    @my_mock.called?(:different_method)
    fail "You asked whether different_method was called; it was not, but particular_method was."
  rescue NotCalled
    # as expected
  end
end

Then /^it should track method calls within individual mock instances$/ do
  @my_mock.mock_method
  another_mock = MyMock.new
  begin
    another_mock.called?(:mock_method)
    fail "mock_method was only called on one instance of MyMock."
  rescue NotCalled
  end
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

Then /^it should let you set up return values in the style of a "([^"]*)" thing$/ do |arg1|
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
  begin
    @my_mock.called? :once_with_result
  rescue NotCalled
    fail "NotCalled should not have been raised, as once_with_result was both defined with a return value and called."
  end
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

Then /^it should make a mockery of toasting bread$/ do
  @slice_of_bread = MyMock.new
  Toaster.new.add(@slice_of_bread).press_switch
  @slice_of_bread.called?(:toast)
end

Then /^it should make a mockery of blending toasters$/ do
  @toaster = MyMock.new
  @toaster.returns(true).from(:blends?)
  Blender.new.blend(@toaster).should == "It blends!"
end

Then /^it should make a mockery of hammering in a nail$/ do
  @nail = MyMock.new
  @hammer = Hammer.new
  3.times { @hammer.hit(@nail) }
  @nail.called?(:hit).should == 3
end