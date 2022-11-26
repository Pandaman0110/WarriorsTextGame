function imageCenterX(image) 
	local image_width = image:getWidth()
	local game_width = push:getWidth()
	local x = game_width / 2 - image_width / 2
	return x
end

function imageCenterY(image) 
	local image_height = image:getHeight()
	local game_height = push:getHeight()
	local y = game_height / 2 - image_height / 2
	return y 
end