states.Menu = {
  t = 0,

  draw = function(s)
    p( "NECAT", 100 )
  end,

  update = function(s, dt)
    s.t = s.t + dt
  end,
}

Base.mixin(states.Menu, State)
