require File.join(File.expand_path(File.dirname(__FILE__)), 'test_dependencies')

describe "testing that your new mocking class works" do
  koan "should make a mockery of toasting bread", 20 do
    @slice_of_bread = MyMock.new
    Toaster.new.add(@slice_of_bread).press_switch
    @slice_of_bread.called?(:toast)
  end

  koan "should make a mockery of blending toasters", 21 do
    @toaster = MyMock.new
    @toaster.returns(true).from(:blends?)
    Blender.new.blend(@toaster).should == "It blends!"
  end

  koan "should make a mockery of hammering in a nail", 22 do
    @nail = MyMock.new
    @hammer = Hammer.new
    3.times { @hammer.hit(@nail) }
    @nail.called?(:hit).should == 3
  end
end if defined? MyMock
