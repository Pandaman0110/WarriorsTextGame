Button = class("Button")

function Button:initialize(x, y, w, h, t)
	self.x = x
	self.y = y 
	self.w = w 
	self.h = h
	t:insert(self)
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

function TextBox:initialize(x, y, w, h, limit, t, align)
	self.x = x 
	self.y = y
	self.text = ""
	self.limit = limit
	self.w = w
	self.h = h
	self.align = align
	t:insert(self)
	self.blink = 2
end

function TextBox:draw()
	love.graphics.setColor(232/255, 209/255, 169/255)
	love.graphics.rectangle("fill", self.x - 4, self.y, self.w, self.h)
	love.graphics.setColor(255, 255, 255)

	textSettings()

	if self.align then 
		love.graphics.printf(self.text, self.x, self.y, windowWidth, self.align, 0, scX())
	else 
		love.graphics.print(self.text, self.x, self.y, 0, scX()) 
	end

	clearTextSettings()
end

function TextBox:textinput(text)
	print(text)
	if self.text == "" or not (self.text:len() >= self.limit) then
		self.text = self.text .. text
	end
end

function TextBox:keypressed(key)
	if key == "backspace" and self.text ~= "" then
       	local byteoffset = utf8.offset(self.text, -1)
       	self.text = (string.sub(self.text, 1, byteoffset - 1))
    elseif key == "space" then
      	self.text = self.text .. "_"
   	end
end

function TextBox:mouseInside(mx, my)
	return mouseInside(mx, my, self.x, self.y, self.w, self.h)
end

function TextBox:getText()
	return self.text
end

function TextBox:isEmpty()
	if self.text == "" then return true else return false end
end

function TextBox:clear()
	self.text = ""
end

function TextBox:setText(text)
	self.text = text
end

Text = class("Text")

function Text:initialize(text, x, y, w, h, t, align)
	self.text = text
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	t:insert(self)
	self.align = align
end

function Text:mouseInside(mx, my)
	return mouseInside(mx, my, self.x, self.y, self.w, self.h)
end

function Text:getText()
	return self.text
end

function Text:draw()
	if self.align then 
		love.graphics.printf(self.text, self.x, self.y, windowWidth, self.align, 0, scX())
	else 
		love.graphics.print(self.text, self.x, self.y, 0, scX()) 
	end
end