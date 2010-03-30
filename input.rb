class Input
  def initialize board
    @board = board
  end

  def dist x1, y1, x2, y2
    lx = (x1 - x2).abs
    ly = (y1 - y2).abs
    Math.sqrt(lx ** 2 + ly ** 2)
  end

  def edge_at mx, my
    @board.hexes.each do |h|
      hx, hy = h.center
      if dist(hx, hy, mx, my) < HEX_RADIUS then
        vector_x = mx - hx
        vector_y = my - hy
        angle = Math.atan2(vector_y, vector_x)
        tri_index = (((180*angle/Math::PI)+30)/60).floor - 3
        return h.edges[tri_index]
      end
    end
    return nil
  end
end
