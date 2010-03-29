require 'edge'

class Hex
  attr_accessor :w, :e, :nw, :ne, :sw, :se
  attr_accessor :edge_w, :edge_e, :edge_nw, :edge_ne, :edge_sw, :edge_se
  def initialize board
    @board = board
    @board.add self if @board
    @edge_w = EmptyEdge.new self
    @edge_e = EmptyEdge.new self
    @edge_nw = EmptyEdge.new self
    @edge_ne = EmptyEdge.new self
    @edge_sw = EmptyEdge.new self
    @edge_se = EmptyEdge.new self
  end

  def expand
    unless @w then
      @w = Hex.new @board
      @w.e = self
      if @nw
        @w.ne = @nw
        @nw.sw = @w
      end
      if @sw
        @w.se = @sw
        @sw.nw = @w
      end
    end

    unless @e then
      @e = Hex.new @board
      @e.w = self
      if @ne
        @e.nw = @ne
        @ne.se = @e
      end
      if @se
        @e.sw = @se
        @se.ne = @e
      end
    end

    unless @nw then
      @nw = Hex.new @board
      @nw.se = self
      if @w
        @nw.sw = @w
        @w.ne = @nw
      end
      if @ne
        @nw.e = @ne
        @ne.w = @nw
      end
    end

    unless @ne then
      @ne = Hex.new @board
      @ne.sw = self
      if @e
        @ne.se = @e
        @e.nw = @ne
      end
      if @nw
        @ne.w = @nw
        @nw.e = @ne
      end
    end

    unless @sw then
      @sw = Hex.new @board
      @sw.ne = self
      if @w
        @sw.nw = @w
        @w.se = @sw
      end
      if @se
        @sw.e = @se
        @se.w = @sw
      end
    end

    unless @se then
      @se = Hex.new @board
      @se.nw = self
      if @e
        @se.ne = @e
        @e.sw = @se
      end
      if @sw
        @se.w = @sw
        @sw.e = @se
      end
    end
  end

  def adjacent_edge edge
    raise "failure" if edge.hex != self
    return @w.edge_e   if edge == @edge_w
    return @e.edge_w   if edge == @edge_e
    return @sw.edge_ne if edge == @edge_sw
    return @se.edge_nw if edge == @edge_se
    return @nw.edge_se if edge == @edge_nw
    return @ne.edge_sw if edge == @edge_ne
  end

  def inspect
    "<Hex:...>"
  end
end
