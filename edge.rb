SPEED ||= 0.1

class Edge
  attr_accessor :hex, :transitioning_with
  def initialize hex
    @hex = hex
    @active = 1.0
  end

  def inspect
    "<Edge:#{object_id}:#{hex.inspect}>"
  end

  def update dt
    @active += dt * SPEED if dt
  end

  def active?
    @active >= 1.0
  end

  def transitioning?
    @active <= 1.0
  end

  def exchange_with edge
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
end

class FlipEdge < Edge
end

class ClockwiseEdge < Edge
end

class CounterClockwiseEdge < Edge
end
