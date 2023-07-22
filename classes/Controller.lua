local ipairs, pairs

Controller = class("Controller")

function Controller:initialize(entity)
	self.entity = entity
	self.x = entity:getX()
	self.y = entity:getY()
	self.circle = shapes.newCircleShape(32, 32, 16)
end

function Controller:getPos()
	return self.x, self.y
end

function Controller:update(dt)
	local vx, vy = 0, 0

	if love.keyboard.isDown("d") then 
		vx = vx + 1
	end
	if love.keyboard.isDown("a") then
		vx = vx - 1
	end
	if love.keyboard.isDown("s") and not (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		vy = vy + 1
	end
	if love.keyboard.isDown("w") then
		vy = vy - 1
	end

	if vx ~= 0 and vy ~= 0 then 
		vx = vx / sqrt2
		vy = vy / sqrt2
	end

	self.circle:move(vx, vy)

	--check collision heres

	--if succes then move them there

	self.x = self.x + vx * 300 * dt
	self.y = self.y + vy * 300 * dt
end

function Controller:draw()
	self.circle:draw()
end

PlayerController = class("PlayerController", Controller)

function PlayerController:initialize()



end

function AiController:initialize()
