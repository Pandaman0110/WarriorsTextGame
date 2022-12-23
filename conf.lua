-- Configuration

-- Make console output appear in sublime text (Doesn't appear to work)
io.stdout:setvbuf("no")


function love.conf(t)
	t.identity = "WTG"
	t.title = "Warriors Text Game"
	t.window.title = "Warriors Text Game"
	t.version = "11.4"
	t.window.width = 1920
	t.window.height = 1080
	t.window.display = 1
	t.window.highdpi = true


	t.modules.joystick = false
	t.modules.physics = false

	t.console = true
end