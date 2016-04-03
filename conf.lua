function love.conf(t)
  t.console = true

  t.window.title = 'Lowres entry'
  t.window.width = 640
  t.window.height = 640
  t.window.minwidth = 64
  t.window.minheight = 64
  t.window.resizable = true

  t.modules.joystick = false
  t.modules.physics = false
end
