require 'edge'

class Hex
  attr_accessor :w, :e, :nw, :ne, :sw, :se

  def initialize board
    @board = board
    @board.add self if @board
    @edges = (0..5).map { |i| EmptyEdge.new(self) }
  end

  def edge_w;  @edges[0]; end
  def edge_nw; @edges[1]; end
  def edge_ne; @edges[2]; end
  def edge_e;  @edges[3]; end
  def edge_se; @edges[4]; end
  def edge_sw; @edges[5]; end

  def edge_w= x;  @edges[0] = x; end
  def edge_nw= x; @edges[1] = x; end
  def edge_ne= x; @edges[2] = x; end
  def edge_e= x;  @edges[3] = x; end
  def edge_se= x; @edges[4] = x; end
  def edge_sw= x; @edges[5] = x; end

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
    return @w.edge_e   if edge == edge_w
    return @e.edge_w   if edge == edge_e
    return @sw.edge_ne if edge == edge_sw
    return @se.edge_nw if edge == edge_se
    return @nw.edge_se if edge == edge_nw
    return @ne.edge_sw if edge == edge_ne
  end

  def replace_edge(old, new)
    case old
    when edge_w:  self.edge_w  = new
    when edge_e:  self.edge_e  = new
    when edge_se: self.edge_se = new
    when edge_sw: self.edge_sw = new
    when edge_ne: self.edge_ne = new
    when edge_nw: self.edge_nw = new
    end
  end

  def swap_edges(old, new)
    old_index = @edges.index old
    new_index = @edges.index new
    @edges[old_index] = new
    @edges[new_index] = old
  end

  def inspect
    "<Hex:...>"
  end
end
