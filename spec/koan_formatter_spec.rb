require 'spec_helper'
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'features', 'support', 'koan_formatter.rb')

describe KoanFormatter do
  before(:each) do
    @stub_formatter = mock { stubs(:step_name) }
    KoanFormatter.set_creation() {|i,j,k| @stub_formatter }
    @koan_formatter = KoanFormatter.new(nil, nil, nil)
  end

  it "should not mark the koan as failed to start with" do
    @koan_formatter.koan_failed?.should be_false
  end

  it "should switch the step output off if the step failed" do
    @koan_formatter.step_name(nil, nil, :failed, nil, nil)
    @koan_formatter.koan_failed?.should be_true
  end

  it "should call step_name on the underlying formatter" do
    @stub_formatter.expects(:step_name).with('one', 'two', :failed, 'three', 'four')
    @koan_formatter.step_name('one', 'two', :failed, 'three', 'four')
    
  end
end

describe KoanFormatter, "Calling undefined methods" do
  it "should defer any undefined methods to the decorated formatter" do
    parameter_one, parameter_two = 'parameter_one', 'parameter_two'
    stub_formatter = mock do
      expects(:send).with(:call_me, parameter_one, parameter_two)
    end
    KoanFormatter.set_creation() {|i,j,k| stub_formatter }
    koan_formatter = KoanFormatter.new(nil, nil, nil)
    koan_formatter.call_me parameter_one, parameter_two
  end
end

