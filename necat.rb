require 'board'

class Necat < Processing::App
  def setup
    smooth
    stroke_width 2
    frame_rate 30
    rect_mode RADIUS

    @cache = {}
    @board = Board.new :size => 3
    @board.randomize

    @frame_time = nil
    $frame_count = 0

    @font = createFont("Arial Bold",48)
  end

  def draw
    t = Time.now
    dt = 1.0 / (t - @frame_time) if @frame_time
    @frame_time = t
    $frame_count += 1

    background 50

    fill 240

    @board.update dt
    @focus_edge = @board.input.edge_at mouseX, mouseY
    @board.hexes.each do |hex|
      draw_hex hex
    end

    textFont(@font, 24)
    text "#{frame_rate.to_i} eXtr3ME FPS",20,40
  end
  
  def draw_edge edge, focus
    a = focus ? 255 : 200

    if focus
      @cache[:focus_extent] ||= -@s
      @cache[:focus_p1]     ||= @h - @r
      @cache[:focus_p2]     ||= @r - @h
      fill 0, 0, 0, a
      begin_shape
      vertex 0, 0
      vertex @cache[:focus_extent], @cache[:focus_p1]
      vertex @cache[:focus_extent], @cache[:focus_p2]
      end_shape
    end

    case edge
    when FlipAdjacentEdge:
      fill 240, 40, 40, a
    when FlipOppositeEdge:
      fill 140, 240, 40, a
    when ClockwiseEdge:
      fill 40, 140, 240, a
    when CounterClockwiseEdge:
      fill 140, 40, 240, a
    else
      fill 10, 10, 20, a
    end

    begin_shape
    @cache[:offset] ||= @r / 8.0
    @cache[:center_offset] ||= @cache[:offset] / -2.0
    @cache[:extent] ||= @cache[:offset] - @s
    @cache[:p1]     ||= @h - @r + @cache[:offset]
    @cache[:p2]     ||= @r - @h - @cache[:offset]
    vertex @cache[:center_offset], 0
    vertex @cache[:extent], @cache[:p1]
    vertex @cache[:extent], @cache[:p2]
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
      fill 40
    else
      focus = false
      fill 20
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

    no_stroke
    hex.edges.each_with_index do |edge, n|
      push_matrix
      rotate(radians(60*n))
      focus_edge = edge == @focus_edge
      draw_edge edge, focus_edge
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
    @last_clicked = @board.input.edge_at mouseX, mouseY
    if @last_clicked and @last_clicked.active?
      @last_clicked.click
    end
  end
end


Necat.new :title => "necat", :width => SCREEN_WIDTH, :height => SCREEN_HEIGHT

