RSpec.describe "group with tagged specs" do
  it "example I'm working now", :focus => true do; end
  it "special example with string", :type => 'special' do; end
  it "special example with symbol", :type => :special do; end
  it "slow example", :skip => true do; end
  it "ordinary example", :speed => 'slow' do; end
  it "untagged example" do; end
end