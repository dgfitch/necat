SIZE = 1.0
WIDTH = 800 * SIZE
HEIGHT = 600 * SIZE

BOARD_WIDTH = 5
BOARD_HEIGHT = 4
#BOARD_WIDTH = 10
#BOARD_HEIGHT = 8

SPEED = 0.01

class Sketch < Processing::App
  

  class Board
    attr_accessor :mouse_pressed

    def initialize(w = BOARD_WIDTH, h = BOARD_HEIGHT)
      @w = w
      @h = h

      @state = []
      h.times do |row|
        line = []
        if row % 2 == 0
          line << nil 
        end
        w.times do |col|
          line << Hex.new(self, row, col)
          line << nil
        end
        @state << line
      end
    end

    def opposite_index n
      case n
      when 0: 3
      when 1: 4
      when 2: 5
      when 3: 0
      when 4: 1
      when 5: 2
      end
    end

    def neighbor_hex(target, n)
      # n is edge number, where 0 is the upper right edge and going clockwise
      row = nil
      col = nil

      @state.each_with_index do |r, i|
        r.each_with_index do |hex, j|
          if hex == target then
            row = i
            col = j
          end
        end
      end

      return nil unless row

      case n
      when 0
        nrow = row - 1
        ncol = col + 1
      when 1
        nrow = row
        ncol = col + 2
      when 2
        nrow = row + 1
        ncol = col + 1
      when 3
        nrow = row + 1
        ncol = col - 1
      when 4
        nrow = row
        ncol = col - 2
      when 5
        nrow = row - 1
        ncol = col - 1
      else
        return nil
      end

      return nil if nrow > @h or nrow < 0 or ncol > @w or ncol < 0
      return nil unless @state[nrow]
      return @state[nrow][ncol]
    end

    def neighbor_edge(target, n)
      hex = neighbor_hex(target, n)
      return nil unless hex
      hex.edges[opposite_index(n)]
    end

    def for_all
      @state.each do |row|
        row.each do |hex|
          yield hex if hex
        end
      end
    end

    def reset_activity
      for_all do |hex|
        hex.reset_activity
      end
    end

    def advance_all
      reset_activity
      for_all do |hex|
        hex.advance_rotate
      end
      for_all do |hex|
        hex.advance_flip
      end
    end

    def draw fps
      r = 350 / @w
      @state.each_with_index do |row, i|
        row.each_with_index do |hex, j|
          hex.draw(fps, r, 10 + r + j * ( 350 * SIZE / @w ), 20 + r + i * ( 500 * SIZE / @h )) if hex
        end
      end
    end
  end

  class Edge
    attr_accessor :hex
    def initialize(hex)
      @hex = hex
      @active = true
      @time = 0
    end

    def prepare
      if @active then
        stroke_width 4
      else
        stroke_width 1
      end
      
      if @hex.focus then
        # TODO: Figure out of this edge is in focus
        @focus = true
        #index = @hex.edges.index(self)
        @alpha = 100 - @time
      else
        @focus = false
        @alpha = 200 - @time
      end
    end

    def draw(fps,s,h,r)
      offset = (-40 * SIZE / BOARD_WIDTH)

      #stroke_width 1
      #stroke 40

      prepare

      line 0, 0, offset, offset

      begin_shape
      vertex offset, offset
      case @hex.edges.index(self)
      when 0
        vertex 0, -r
        vertex s, h - r
      when 1
        vertex s, h - r
        vertex s, r - h
      when 2
        vertex s, r - h
        vertex 0, r
      when 3
        vertex 0, r
        vertex -s, r - h
      when 4
        vertex -s, r - h
        vertex -s, h - r
      when 5
        vertex -s, h - r
        vertex 0, -r
      end
      vertex offset, offset
      end_shape

      if @focus and @hex.board.mouse_pressed == LEFT then
        self.advance
      elsif not @active then
        @time = @time - (fps * SPEED)
        if @time < 0
          activate
        end
      end
    end

    def activate
      @hex.advance
      @active = true 
    end

    def reset_activity
      @active = true
    end

    def inactivate
      @active = false
      @time = 100
    end
  end

  class ClockwiseEdge < Edge
    def prepare
      super
      stroke 20, 50, 200, @alpha
      fill 40, 70, 220, @alpha
    end

    def activate
      @active = true 
    end

    def advance
      return unless @active
      inactivate
      puts "clockwise"
      @hex.rotate
    end
  end

  class FlipEdge < Edge
    def prepare
      super
      stroke 200, 50, 50, @alpha
      fill 220, 70, 70, @alpha
    end

    def advance
      return unless @active
      puts "flip"
      index = @hex.index_of self
      opposite = @hex.board.opposite_index index
      other_hex = @hex.neighbor_of self
      return unless other_hex
      other_edge = other_hex.edges[opposite]
      if not other_edge or not other_edge.kind_of? FlipEdge then
        inactivate
        other_hex.edges[opposite] = self
        @hex.edges[index] = other_edge
        other_edge.hex = @hex if other_edge
        @hex = other_hex
      end
    end
  end

  class Hex
    attr_accessor :x, :y, :r
    attr_reader :edges, :board, :focus
    def initialize(board, x = 0, y = 0)
      @board = board
      @edges = [ random_edge, random_edge, random_edge, random_edge, random_edge, random_edge ]
    end

    def random_edge
      if random(1) > 0.9 then
        ClockwiseEdge.new(self)
      elsif random(1) > 0.9 then
        FlipEdge.new(self)
      else
        nil
      end
    end
    
    def draw(fps, r, x, y)
      @r ||= r
      @h ||= @r / 2
      @s ||= Math.sin(radians(60)) * @r

      d = dist(x, y, mouseX, mouseY)
      # TODO: Should do an actual intersection if we're close
      if d < @r then
        @focus = true
        fill 240
      else
        @focus = false
        fill 200
      end

      push_matrix
      translate x, y
      stroke_width 2
      stroke 0
      begin_shape
      vertex 0, -@r
      vertex @s, @h - @r
      vertex @s, @r - @h
      vertex 0, @r
      vertex -@s, @r - @h
      vertex -@s, @h - @r
      vertex 0, -@r
      end_shape

      stroke_width 1
      stroke 100
      line 0, -@r, 0, @r
      line @s, @h - @r, -@s, @r - @h
      line @s, @r - @h, -@s, @h - @r
      
      @edges.each { |edge| edge.draw(fps,@s,@h,@r) if edge }
      
      pop_matrix
    end

    def neighbor(n)
      @board.neighbor_hex(self, n)
    end

    def neighbor_edge(n)
      @board.neighbor_edge(self, n)
    end

    def neighbor_of(edge)
      index = @edges.index(edge)
      neighbor(index)
    end

    def index_of(edge)
      @edges.index(edge)
    end

    def reset_activity
      @edges.each do |e|
        e.reset_activity if e
      end
    end

    def advance
      advance_flip
      advance_rotate
    end

    def advance_flip
      @edges.each do |e|
        if e and e.kind_of? FlipEdge then
          e.advance
        end
      end
    end

    def advance_rotate
      @edges.each do |e|
        if e and e.kind_of? ClockwiseEdge then
          e.advance
        end
      end
    end

    def rotate
      x = @edges.pop
      @edges.unshift x
    end
  end
  

  def setup
    smooth
    #no_stroke
    stroke_width 2
    frame_rate 30
    rect_mode RADIUS

    @board = Board.new

    @frame_time = nil
    $frame_count = 0
  end


  def draw
    t = Time.now
    fps = 1.0 / (t - @frame_time) if @frame_time
    @frame_time = t
    $frame_count += 1

    background 50

    fill 240

    @board.draw fps
  end

  def key_pressed
    case key
      when 'a' then @board.advance_all
    end
  end

  def mouse_pressed
    @board.mouse_pressed = mouse_button
  end

  def mouse_released
    @board.mouse_pressed = nil
  end
end


Sketch.new(:width => WIDTH, :height => HEIGHT, :title => "Necat")
