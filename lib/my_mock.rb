class MyMock
  def initialize
    @method_returns, @method_calls = {}, []
  end

  def called? method_name
    raise NotCalled.new method_name unless @method_calls.include? method_name
    @method_calls.count {|method| method_name == method }
  end
#
#  def method_missing method_name, *args
#    super method_name, *args unless args.empty?
#    @method_calls << method_name
#    return nil
#  end
#
#  def returns return_value
#    @return_value = return_value
#    self
#  end
#
#  def from method_name
#    @method_returns[method_name] = @return_value
#    @return_value = nil
#    self.class.instance_eval do
#      define_method(method_name) do
#        @method_calls << method_name
#        @method_returns[method_name]
#      end
#    end
#  end
end