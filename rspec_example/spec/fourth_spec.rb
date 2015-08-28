RSpec.describe Array do
  describe "#length" do
    it "is the number of items" do
      expect(Array.new([1,2,3]).length).to eq 3
    end
  end
end