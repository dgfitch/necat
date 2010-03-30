class Edge
  attr_accessor :hex, :transitioning_with
  def initialize hex
    @hex = hex
    @active = 1.0
  end

  def inspect
    "<Edge:#{hex.edges.index self}:#{hex.inspect}>"
  end

  def update dt
    @active += dt * (SPEED || 0.1) if dt
  end

  def active?
    @active >= 1.0
  end

  def transitioning?
    @active <= 1.0
  end

  def exchange_with edge
    # For other types of movement [rotation] it may be better to model this as 
    # "transitioning to" a hex and index position...
    @transitioning_with = edge
    edge.transitioning_with = self
    @active = 0.0
    if @hex == edge.hex then
      @hex.swap_edges(self, edge)
    else
      @hex.replace_edge(self, edge)
      edge.hex.replace_edge(edge, self)
      @hex, edge.hex = edge.hex, @hex if @hex != edge.hex
    end
  end
end

class EmptyEdge < Edge
  def click
  end
end

class FlipOppositeEdge < Edge
  def click
    opposite = (hex.edges.index(self) + 4) % 6 - 1
    other = hex.edges[opposite]
    exchange_with other if other
  end
end

class FlipAdjacentEdge < Edge
  def click
    other = hex.adjacent_edge(self)
    exchange_with other if other
  end
end

class ClockwiseEdge < Edge
  def click
    @active = 0.0
    hex.rotate_clockwise
  end
end

class CounterClockwiseEdge < Edge
  def click
    @active = 0.0
    hex.rotate_counterclockwise
  end
end
