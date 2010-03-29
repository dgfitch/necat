require 'hex'

describe Hex do
  it "defaults to 6 empty edges" do
    hex = Hex.new nil
    hex.edge_w.class.should == EmptyEdge
    hex.edge_e.hex.should == hex
    hex.edge_e.should be_active
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
    e1.should be_transitioning
  end

  it "updates active on edges" do
    hex = Hex.new nil
    e1 = hex.edge_w
    e2 = hex.edge_e
    e1.exchange_with e2
    e1.should_not be_active
    hex.update 10000
    e1.should be_active
  end
end

