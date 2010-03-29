SIZE = 1.0
SCREEN_WIDTH = 600.0
SCREEN_HEIGHT = 600.0

BOARD_SIZE = 4
SPEED = 0.1
DENSITY = 0.4

require 'board'

class Necat < Processing::App
  def setup
    smooth
    #no_stroke
    stroke_width 2
    frame_rate 30
    rect_mode RADIUS

    @board = Board.new BOARD_SIZE

    @frame_time = nil
    $frame_count = 0
    puts SCREEN_WIDTH
  end

  def draw
    t = Time.now
    dt = 1.0 / (t - @frame_time) if @frame_time
    @frame_time = t
    $frame_count += 1

    background 50

    fill 240

    @board.update dt
    @board.hexes.each do |hex|
      draw_hex(hex, BOARD_SIZE / 0.12)
    end
  end

  def draw_hex hex, r
    x = (SCREEN_WIDTH  / 2.0) + (hex.x * r)
    y = (SCREEN_HEIGHT / 2.0) + (hex.y * r * 1.75)
    @r ||= r
    @h ||= @r / 2
    @s ||= Math.sin(radians(60)) * @r

    d = dist(x, y, mouseX, mouseY)
    # TODO: Should do an actual intersection if we're close
    if d < @r then
      #hex.focus = true
      fill 240
    else
      #hex.focus = false
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
    
    #@edges.values.compact.each { |edge| edge.draw(fps,@s,@h,@r) }
    
    pop_matrix
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


Necat.new :title => "necat", :width => SCREEN_WIDTH, :height => SCREEN_HEIGHT

