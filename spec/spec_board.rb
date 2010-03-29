require 'board.rb'

describe Board do
  it "has 1 hex for radius 0" do
    board = Board.new 0
    board.hexes.should == 1
  end

  it "has 61 hexes for radius 4" do
    board = Board.new 4
    board.hexes.should == 61
  end
end

