class MyMock
  def initialize
    @method_calls = []
  end
  
  def called? method_name
    raise NotCalled.new unless @method_calls.include? method_name
    @method_calls.count {|method| method == method_name }
  end

  def method_missing method_name, *args
    super method_name, args unless args.empty?
    @method_calls << method_name
    return nil
  end

  def returns value
    @value = value
    return self
  end

  def from method_name
    the_value = @value
    (class << self; self; end).instance_eval do
      define_method(method_name) do
        @method_calls << method_name
        return the_value
      end
    end
    @value = nil
  end
end