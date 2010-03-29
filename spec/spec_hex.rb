require 'hex'

describe Hex do
  it "defaults to 6 empty edges" do
    hex = Hex.new nil
    hex.edge_w.class.should == EmptyEdge
    hex.edge_e.hex.should == hex
  end

  it "calculates opposite edges" do
    hex = Hex.new nil
    hex.expand
    hex.adjacent_edge(hex.edge_w).should == hex.w.edge_e
    hex.adjacent_edge(hex.edge_w).hex.should == hex.w
  end
end

