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

end

