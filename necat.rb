SIZE = 1.0
WIDTH = 800 * SIZE
HEIGHT = 600 * SIZE

class Sketch < Processing::App
  
  class Board
    def initialize(w = 10, h = 8)
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

    def neighbor(row, col, n)
      # n is edge number, where 0 is the upper right edge and going clockwise
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
      end

      return nil if nrow > @h or nrow < 0 or ncol > @w or ncol < 0
      return state[nrow][ncol]
    end

    def advance
      @state.each do |row|
        row.each do |hex|
          hex.advance_flip
        end
      end
      @state.each do |row|
        row.each do |hex|
          hex.advance_rotate
        end
      end
    end

    def draw
      @state.each_with_index do |row, i|
        row.each_with_index do |hex, j|
          hex.draw(30, 100 + j * 28, 100 + i * 48) if hex
        end
      end
    end
  end

  class Hex
    attr_accessor :x, :y, :r
    def initialize(board, x = 0, y = 0)
      @board = board
      @edges = [ random_edge, random_edge, random_edge, random_edge, random_edge, random_edge ]
    end

    def random_edge
      if random(1) > 0.9 then
        random(3).to_i
      else
        0
      end
    end
    
    def draw(r, x, y)
      @r ||= r
      @h ||= @r / 2
      @s ||= Math.sin(radians(60)) * @r

      d = dist(x, y, mouseX, mouseY)
      # TODO: Should do an actual intersection if we're close
      if d < @r then
        fill 240
      else
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
      
      6.times { |x| draw_edge x }
      
      pop_matrix
    end

    def neighbor(n)
      @board.neighbor(@x, @y, n)
    end

    def draw_edge(n)
      stroke_width 3

      case @edges[n]
      when 0
        return
      when 1
        stroke 200, 50, 50
        fill 220, 70, 70
      when 2
        stroke 20, 50, 200
        fill 40, 70, 220
      end

      begin_shape
      vertex 0, 0
      case n
      when 0
        vertex 0, -@r
        vertex @s, @h - @r
      when 1
        vertex @s, @h - @r
        vertex @s, @r - @h
      when 2
        vertex @s, @r - @h
        vertex 0, @r
      when 3
        vertex 0, @r
        vertex -@s, @r - @h
      when 4
        vertex -@s, @r - @h
        vertex -@s, @h - @r
      when 5
        vertex -@s, @h - @r
        vertex 0, -@r
      end
      vertex 0, 0
      end_shape
    end

    def advance_flip
    end

    def advance_rotate
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
    @frame_count = 0
  end


  def draw
    t = Time.now
    fps = 1.0 / (t - @frame_time) if @frame_time
    @frame_time = t
    @frame_count += 1

    background 50

    fill 240
    @board.draw
  end

  def key_pressed
    case key
      when 'a' then @board.advance
    end
  end
end


Sketch.new(:width => WIDTH, :height => HEIGHT, :title => "Necat")
