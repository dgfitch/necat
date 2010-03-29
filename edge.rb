class Edge
  attr_accessor :hex
  def initialize hex
    @hex = hex
  end

  def inspect
    "<Edge:#{object_id}:#{hex.inspect}>"
  end

  def exchange_with edge
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
