## This is my 'ideal' solution to the koan.  It's commented out as it currently
## automatically gets loaded by the koan runner.
#class MyMock
#  def initialize
#    @called_methods, @return_values = [], {}
#  end
#
#  def called? method_name
#    raise NotCalled.new unless @called_methods.include? method_name
#    @called_methods.count {|method| method == method_name}
#  end
#
#  def returns return_value
#    @return_value = return_value
#    return self
#  end
#
#  def from method_name
#    @return_values[method_name] = @return_value
#    @return_value = nil
#  end
#
#  def method_missing method_name, *args
#    super method_name, *args unless args.empty?
#    @called_methods << method_name
#    return @return_values[method_name]
#  end
#end