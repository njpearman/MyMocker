Given /^the koan is (\d+) percent complete$/ do |required_completion|
  pending("You need to complete more of the Koan to get this running") if current_progress < required_completion.to_i
end

Given /^I have a mocked slice of bread$/ do
  @slice_of_bread = MyMock.new
end

When /^I put the bread into a toaster$/ do
  Toaster.new.add(@slice_of_bread).press_switch
end

Then /^the bread should be toasted$/ do
  @slice_of_bread.called?(:toast)
end

Given /^I have a mocked nail$/ do
  @nail = MyMock.new
end

When /^I hit the nail with a hammer (\d+) times$/ do |hit_count|
  @hammer = Hammer.new
  hit_count.to_i.times { @hammer.hit(@nail) }
end

Then /^the nail should have been hit (\d+) times$/ do |hit_count|
  @nail.called?(:hit).should == hit_count.to_i
end

Given /^I have a toaster$/ do
  @toaster = MyMock.new
end

Given /^the toaster blends$/ do
  @toaster.returns(true).from(:blends?)
end

When /^I put the toaster in a blender$/ do
  @does_it_blend = Blender.new.blend(@toaster)
end

Then /^it should tell me that it blends$/ do
  @does_it_blend.should == "It blends!"
end

