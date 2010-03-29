require 'board'

describe Board do
  it "has 1 hex for radius 0" do
    board = Board.new 0
    board.hexes.length.should == 1
  end

  it "has 7 hexes for radius 1" do
    board = Board.new 1
    board.hexes.length.should == 7
  end

  it "has 61 hexes for radius 4" do
    board = Board.new 4
    board.hexes.length.should == 61
  end

  it "has the correct aliases" do
    board = Board.new 2
    c = board.center
    c.w.e.should == c
    c.sw.ne.should == c
    c.w.w.e.e.should == c
    c.sw.w.should == c.w.sw
  end

  it "calculates x and y coordinates for a given hex" do
    board = Board.new 2
    c = board.center
    c.x.should == 0
    c.y.should == 0
    c.w.x.should == -2
    c.w.y.should == 0
    c.ne.x.should == 1
    c.ne.y.should == -1
  end

end

