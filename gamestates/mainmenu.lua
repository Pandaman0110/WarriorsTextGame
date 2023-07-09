local pairs, ipairs = pairs, ipairs

mainmenu = class("mainmenu")

function mainmenu:initialize()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = Array:new()

	self.play_button = ImageButton:new(32, 72, love.graphics.newImage("Images/playbutton.png"), self.buttons)
	self.editor_button = ImageButton:new(32, 152, love.graphics.newImage("Images/editorbutton.png"), self.buttons)
	self.options_button = ImageButton:new(32, 232, love.graphics.newImage("Images/optionsbutton.png"), self.buttons)
end

function mainmenu:mousepressed(x, y, button)
	--this is because of push and the resolution handiling
	local mx, my = push:toGame(x, y)

	self:checkButtons(mx, my, button)
end


function mainmenu:draw()
	self:drawBackground()
	self:drawButtons()
end

----------------------------------------------------------------------------------------------

function mainmenu:checkButtons(mx, my, button)
	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			if _button == self.play_button then gamestate.switch(play) end
			if _button == self.load_game then gamestate.switch(loadgame) end
			if _button == self.options_button then gamestate.switch(options) end
			if _button == self.editor_button then gamestate.switch(editor) end
		end
	end
end

function mainmenu:drawButtons()
	for i, _button in self.buttons:iterator() do
		_button:draw()
	end
end

function mainmenu:drawBackground()
	love.graphics.draw(self.background, 0, 0, 0, 640 / self.background:getWidth(), 360 / self.background:getHeight())
end