require 'board'

describe Board do
  it "has 1 hex for radius 0" do
    board = Board.new :size => 0
    board.hexes.length.should == 1
  end

  it "has 7 hexes for radius 1" do
    board = Board.new :size => 1
    board.hexes.length.should == 7
  end

  it "has 61 hexes for radius 4" do
    board = Board.new :size => 4
    board.hexes.length.should == 61
  end

  it "has the correct aliases" do
    board = Board.new :size => 2
    c = board.center
    c.w.e.should == c
    c.sw.ne.should == c
    c.w.w.e.e.should == c
    c.sw.w.should == c.w.sw
  end

  it "calculates x and y coordinates for a given hex" do
    board = Board.new :size => 2
    c = board.center
    c.x.should == 0
    c.y.should == 0
    c.w.x.should == -2
    c.w.y.should == 0
    c.ne.x.should == 1
    c.ne.y.should == -1
  end

  it "helps hexes calculate center" do
    board = Board.new :size => 2
    board.center.center.should == [SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0]
  end

  it "turns screen coordinates into edges" do
    board = Board.new :size => 4
    edge = board.input.click( (SCREEN_WIDTH / 2 - 5), (SCREEN_HEIGHT / 2) )
    edge.should == board.center.edge_w
  end
end

