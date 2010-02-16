states = {}
State = Base:create({
  draw = function(s) end,
  update = function(s, dt) end,
  activate = function(s) end,
  initialize = function(s) end,
  change = function(i)
    S = i
    S:activate()
  end,
})

requireDir "states/"
