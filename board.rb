SIZE = 1.0
BOARD_SIZE = 3
HEX_RADIUS = 120.0 * SIZE / BOARD_SIZE

SPEED = 0.1
DENSITY = 0.4
SCREEN_WIDTH = 600.0
SCREEN_HEIGHT = 600.0

require 'hex'
require 'input'
require 'output'

class Board
  attr_reader :hexes, :center, :input, :output, :hex_spacing_h, :hex_spacing_w

  def initialize opts={}
    size = opts[:size] || BOARD_SIZE
    radius = opts[:hex_radius] || HEX_RADIUS
    @hex_spacing_h = radius * 1.75
    @hex_spacing_w = radius
    @hexes = []
    @center = Hex.new self
    @input  = Input.new self
    @output = Output.new self
    (1..size).each do |i|
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
end
