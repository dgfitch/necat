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

  it "exchanges edges inside itself" do
    hex = Hex.new nil
    e1 = hex.edge_w
    e2 = hex.edge_e
    e1.exchange_with e2
    hex.edge_w.should == e2
    hex.edge_e.should == e1
  end

  it "exchanges edges with other hexes" do
    hex = Hex.new nil
    hex.expand
    e1 = hex.edge_w
    e2 = hex.w.edge_e
    e1.exchange_with e2
    hex.edge_w.should == e2
    hex.w.edge_e.should == e1
  end
end

