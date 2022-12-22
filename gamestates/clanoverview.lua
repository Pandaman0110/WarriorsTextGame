clanoverview = {}

function clanoverview:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local _next = love.graphics.NewImage("Images/next.png")
	self.next_button = Button:new(480, 400, _next)

	table.insert(self.buttons, self.next_button)
end
