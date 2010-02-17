class Sketch < Processing::App
  
  class Hex
    attr_accessor :x, :y, :r, :m, :vec
    def initialize(r = 0.0, x = 0.0, y = 0.0)
      @x, @y, @r = x, y, r
      @h = @r / 2
      @s = Math.sin(radians(60)) * @r
    end
    
    def draw
      d = dist(@x, @y, mouseX, mouseY)
      # TODO: Should do an actual intersection if we're close
      if d < @r then
        fill 240
      else
        fill 200
      end
      push_matrix
      translate @x, @y
      begin_shape
      vertex 0, -@r
      vertex @s, @h - @r
      vertex @s, @r - @h
      vertex 0, @r
      vertex -@s, @r - @h
      vertex -@s, @h - @r
      vertex 0, -@r
      end_shape
      pop_matrix
    end
  end
  

  def setup
    smooth
    #no_stroke
    stroke_width 2
    frame_rate 30
    rect_mode RADIUS

    @hexes = []
    #@hexes << Hex.new(80, 200, 200)
    @hexes << Hex.new(30, 100, 100)
    @hexes << Hex.new(30, 160, 100)
    @hexes << Hex.new(30, 220, 100)
    @hexes << Hex.new(30, 280, 100)
    @hexes << Hex.new(30, 130, 150)
    @hexes << Hex.new(30, 190, 150)
    @hexes << Hex.new(30, 250, 150)
    @hexes << Hex.new(30, 310, 150)

    @frame_time = nil
    @frame_count = 0
  end


  def draw
    t = Time.now
    fps = 1.0 / (t - @frame_time) if @frame_time
    @frame_time = t
    @frame_count += 1

    background 50

    # move the balls 
    fill 240
    @hexes.each do |hex|
      hex.draw
    end
  end

end


Sketch.new(:width => 400, :height => 400, :title => "Necat")
