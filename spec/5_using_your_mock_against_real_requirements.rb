require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

describe "testing that your new mocking class works" do
  it "should make a mockery of toasting bread" do
    @slice_of_bread = MyMock.new
    Toaster.new.add(@slice_of_bread).press_switch
    @slice_of_bread.called?(:toast)
  end

  it "should make a mockery of blending toasters" do
    @toaster = MyMock.new
    @toaster.returns(true).from(:blends?)
    Blender.new.blend(@toaster).should == "It blends!"
  end

  it "should make a mockery of hammering in a nail" do
    @nail = MyMock.new
    @hammer = Hammer.new
    3.times { @hammer.hit(@nail) }
    @nail.called?(:hit).should == 3
  end
end