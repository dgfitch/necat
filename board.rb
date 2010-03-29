SPEED = 0.1
DENSITY = 0.1

require 'hex'

class Board
  attr_reader :hexes, :center
  def initialize n
    @hexes = []
    @center = Hex.new self
    (1..n).each do |i|
      current_hexes = @hexes.clone
      current_hexes.each {|x| x.expand}
    end
  end
  def add x
    @hexes << x
  end
  
  def update dt
    @hexes.each { |h| h.update dt }
  end

  def inspect
    "<Board:#{hexes.length} hexes>"
  end

  def randomize
    @hexes.each &:randomize
  end

  def click
  end
end
