When /^a new MyMock instance is created$/ do
  defined?(MyMock).should be_true, koan_fail_message("MyMock hasn't been defined as a class.  Put it in the my_mock.rb file.")
  @my_mock = MyMock.new
end