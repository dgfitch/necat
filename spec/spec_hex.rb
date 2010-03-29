require 'hex'

describe Hex do
  it "defaults to 6 empty edges" do
    hex = Hex.new
    hex.edge_w.class.should == EmptyEdge
  end
end

