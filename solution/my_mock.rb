class MyMock
  def initialize
    @argument_stack, @called_methods, @method_values = [], [], {}
  end

  def called? method_name, options={}
    expected_arg = options[:with]
    called_arg = @argument_stack.pop
    raise NotCalled.new if !@called_methods.include?(method_name) || (expected_arg && expected_arg != called_arg) 
    @called_methods.count {|method| method == method_name}
  end

  def method_missing method_name, *args
    super if args.size > 1
    @argument_stack << args[0]
    @called_methods << method_name
    return @method_values[method_name]
  end

  def returns return_value
    @return_value = return_value
    return self
  end

  def from method_name
    @method_values[method_name] = @return_value
    @return_value = nil
  end
end
