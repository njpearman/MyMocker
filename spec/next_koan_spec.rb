require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'next_koan.rb')

describe NextKoan do
  before(:each) do
    @next_spec = NextKoan.new
  end

  it "should run the first run" do
    @next_spec.run?.should be_true
  end

  it "should not run the second run before next stage is set" do
    @next_spec.run?
    @next_spec.run?.should be_false
  end

  it "should run the second run when the next stage has been set" do
    @next_spec.run?
    @next_spec.next_stage
    @next_spec.run?.should be_true
  end
end