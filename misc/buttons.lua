Button = class("Button")

function Button:initialize(x, y, w, h, t)
	self.x = x
	self.y = y 
	self.w = w 
	self.h = h
	table.insert(t, self)
end

function Button:mouseInside(mx, my)
	return mouseInside(mx, my, self.x, self.y, self.w, self.h)
end

function Button:getX()
	return self.x
end

function Button:getY()
	return self.y 
end

function Button:getWidth()
	return self.w 
end 

function Button:getHeight()
	return self.h 
end

function Button:setX(x)
	self.x = x 
end

function Button:setY(y)
	self.y = y 
end

function Button:setWidth(w)
	self.w = w 
end

function Button:setHeight(h)
	self.h = h  
end

function Button:draw()

end

ImageButton = class("ImageButton", Button)

function ImageButton:initialize(x, y, image, t)
	self.image = image
	Button.initialize(self, x, y, self.image:getWidth(), self.image:getHeight(), t)
end

function ImageButton:getImage()
	return self.image 
end 

function ImageButton:setImage(image)
	self.image = image
end

function ImageButton:draw()
	love.graphics.draw(self.image, self.x, self.y)
end

ObjectButton = class("ObjectButton", ImageButton)

function ObjectButton:initialize(x, y, object, image, t)
	self.object = object
	ImageButton.initialize(self, x, y, image, t)
end

function ObjectButton:getObject()
	return self.object 
end

function ObjectButton:setObject(object)
	self.object = object 
end

TextBox = class("TextBox")

function TextBox:initialize(x, y, limit)
	self.x = x 
	self.y = y
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