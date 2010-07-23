class MyMock
  def initialize
    @methods = {}
  end

  def method_missing method_name, *args
    @methods[method_name] = 0 unless @methods[method_name]
    @methods[method_name] = @methods[method_name] + 1
    return nil
  end

  def has_called? expected_method
    @methods.keys.any? {|method_name| method_name == expected_method}
  end

  def call_count method_name
    @methods[method_name] || 0
  end

  def returns expected_value
    @return_value = expected_value
    return self
  end

  def from method_name
    return_values ||= {}
    return_values[:method_name] = @return_value
    create_method(method_name) { return_values[:method_name] }
    #(class << self; self; end).instance_eval { define_method(method_name) { return_values[:method_name] } }
  end

  private
  def create_method method_name, &block
    (class << self; self; end).instance_eval { define_method method_name, &block } if block_given?
  end
end