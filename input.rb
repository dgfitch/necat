class Input
  def initialize board
    @board = board
  end

  def dist x1, y1, x2, y2
    lx = (x1 - x2).abs
    ly = (y1 - y2).abs
    Math.sqrt(lx ** 2 + ly ** 2)
  end

  def click mx, my
    @board.hexes.each do |h|
      hx, hy = h.center
      if dist(hx, hy, mx, my) < HEX_RADIUS then
        return h.edge_w
      end
    end
    return nil
  end
end
