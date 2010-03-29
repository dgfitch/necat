class Edge
  attr_accessor :hex
  def initialize hex
    @hex = hex
  end

  def inspect
    "<Edge:#{hex.to_s}>"
  end
end

class EmptyEdge < Edge
end

class FlipEdge < Edge
end
