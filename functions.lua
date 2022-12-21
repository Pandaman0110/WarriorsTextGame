-- this file is just for general functions 


--these are for putting buttons in the middle of the screen, not the center coordiantes of the image
function imageCenterX(image) 
	local image_width = image:getWidth()
	local game_width = Push:getWidth()
	local x = game_width / 2 - image_width / 2
	return x
end

function imageCenterY(image) 
	local image_height = image:getHeight()
	local game_height = Push:getHeight()
	local y = game_height / 2 - image_height / 2
	return y 
end

--checks if the mouse is inside of a rectangle
function mouseInside(mouseX, mouseY, rectX, rectY, rectWidth, rectHeight)
	if mouseX > rectX and mouseX < (rectX + rectWidth) and mouseY > rectY and mouseY < (rectY + rectHeight) then
		return true
	else return false end
end

function clear()
	love.graphics.setColor(255,255,255,1)
end

function textSettings()
	love.graphics.setColor(58/255, 31/255, 12/255)
end

function scX()
	return 1/xScale
end

function scY()
	return 1/yScale
end