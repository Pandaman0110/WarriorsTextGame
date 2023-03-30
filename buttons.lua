--contains button and textbox classes

--Button class

Button = class("Button")

function Button:initialize(x, y, image, w, h)
	self.image = image
	self.x = x
	self.y = y
	self.width = 0
	self.height = 0
	if image then 
		self.width = self.image:getWidth()
		self.height = self.image:getHeight()
	elseif not image then
		self.width = w
		self.height = h
	end
end

function Button:update(dt)
end

function Button:mouseInside(mx, my)
	return mouseInside(mx, my, self.x, self.y, self.width, self.height)
end

function Button:draw()
	love.graphics.draw(self.image, self.x, self.y)
end 

function Button:getX()
	return self.x 
end

function Button:getY()
	return self.y 
end

function Button:getWidth()
	return self.width
end

function Button:getHeight()
	return self.height
end

function Button:getImage()
	return self.image
end

function Button:setImage(image)
	self.image = image
end

ObjectButton = class("ObjectButton", Button)

function ObjectButton:initialize(x, y, object)
	self.object = object
	self.image = object:getImage()
	Button.initialize(self, x, y, self.image)
end

function ObjectButton:getObject()
	return self.object
end

function ObjectButton:setObejct(object)
	self.object = object
end

function ObjectButton:mouseInside(mx, my)
	return mouseInside(mx, my, self.x, self.y, self.width, self.height)
end

--TextBox class, inherited from button

TextBox = class("TextBox", Button)

function TextBox:initialize(x, y, limit)
	Button.initialize(self, x, y) --calls parents constructor, : operator Button.initialize(self, x, y, image)
	self.active = false
	self.text = ""
	self.limit = limit
end

function TextBox:draw()
	if self.active == true then 
		love.graphics.print(self.text, self.x, self.y, 0, scX())
	end
end

-- handles some basic text functions
function TextBox:keypressed(key)
	if self.active == true then
		if key == "backspace" and self.text ~= "" then
      	 	local byteoffset = utf8.offset(self.text, -1)
      	 	self.text = (string.sub(self.text, 1, byteoffset - 1))
      	elseif key == "space" then
      		self.text = self.text .. "_"
      	elseif key == "return" or key == "lshift" or key == "rshift" or key == "lalt" or key == "ralt" or key == "backspace" then
   		elseif #self.text <= self.limit then 
    		self.text = self.text .. key
   		end
   	end
end

function TextBox:isActive()
	return self.active
end

function TextBox:getText()
	return self.text
end

function TextBox:isEmpty()
	local empty = false
	if self.text == "" then empty = true end
	return empty
end

function TextBox:activate()
	self.active = true
end

function TextBox:deactivate()
	self.active = false
	self.text = ""
end

--this should be used when typing text
function TextBox:addText(text)
	self.text = self.text .. text
end

--when u just wanna set the text
function TextBox:setText(text)
	self.text = text
end

TextButton = class("TextButton", button)

function TextButton:initialize(x, y, image)
	Button.initialize(self, x, y, image)
	self.text = ""
end

function TextButton:draw()
	love.graphics.draw(self.image, self.x, self.y)
	love.graphics.print(self.text)
end

function TextButton:getText()
	return self.text
end

function TextButton:setText(text)
	self.text = text
end

InvisibleButton = class("InvisibleButton", button)

function InvisibleButton:initialize(x, y, w, h, object)
	Button.initialize(self, x, y, nil, w, h)
	self.object = object
end

function InvisibleButton:getObject()
	return self.object
end

function InvisibleButton:setObejct(object)
	self.object = object
end

function InvisibleButton:mouseInside(mx, my)
	return mouseInside(mx, my, self.x, self.y, self.width, self.height)
end