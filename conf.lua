-- Configuration

-- Make console output appear in sublime text (Doesn't appear to work)

function love.conf(t)
	t.identity = "WTG"
	t.title = "Warriors Text Game"
	t.window.title = "Warriors Text Game"
	t.version = "11.4"
	t.window.display = 1
	t.window.highdpi = true
	t.window.vsync = 1


	t.modules.joystick = false
	t.modules.physics = false
	t.modules.video = false 

	t.console = true
end