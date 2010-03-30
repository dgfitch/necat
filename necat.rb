require 'board'

class Necat < Processing::App
  def setup
    smooth
    stroke_width 2
    frame_rate 30
    rect_mode RADIUS

    @board = Board.new
    @board.randomize

    @frame_time = nil
    $frame_count = 0
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
      draw_hex hex
    end
  end
  
  def draw_edge edge, focus, r, s, h
    a = focus ? 180 : 255
    case edge
    when FlipEdge:
      fill 240, 40, 40, a
      stroke 120, 20, 20
    when ClockwiseEdge:
      fill 40, 140, 240, a
      stroke 20, 40, 120
    when CounterClockwiseEdge:
      fill 140, 40, 240, a
      stroke 40, 20, 120
    else
      fill 10, 10, 20, a
      stroke 0
    end
    begin_shape
    offset = r / 8.0
    vertex -offset/2.0, 0
    vertex -s + offset, h - r + offset
    vertex -s + offset, r - h - offset
    end_shape
  end

  def draw_hex hex
    x, y = hex.center
    @r ||= HEX_RADIUS
    @h ||= @r / 2
    @s ||= Math.sin(radians(60)) * @r

    # TODO: Should do an actual intersection if we're close
    # TODO: Would also be nice to figure out what edge triangle is closest
    if dist(x, y, mouseX, mouseY) < @r then
      focus = true
      @last_focus = hex
      fill 180
    else
      focus = false
      fill 40
    end

    push_matrix
    translate x, y
    stroke_width 2.0 * SIZE
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

    stroke_width 1.0 * SIZE
    (0..5).each do |n|
      push_matrix
      rotate(radians(60*n))
      draw_edge hex.edges[n], focus, @r, @s, @h
      pop_matrix
    end
    
    pop_matrix
  end

  def key_pressed
    case key
      when 'a' then @board.advance_all
    end
  end

  def mouse_pressed
    @last_clicked = @board.input.click mouseX, mouseY
  end

  def mouse_released
  end
end


Necat.new :title => "necat", :width => SCREEN_WIDTH, :height => SCREEN_HEIGHT

