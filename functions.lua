-- this file is just for general functions
local ipairs, pairs = ipairs, pairs

local string_meta = getmetatable('')

function string_meta:__index( key )
    local val = string[ key ]
    if ( val ) then
        return val
    elseif ( tonumber( key ) ) then
        return self:sub( key, key )
    else
        error( "attempt to index a string value with bad key ('" .. tostring( key ) .. "' is not part of the string library)", 2 )
    end
end

--these are for putting buttons in the middle of the screen, not the center coordiantes of the image
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

--checks if the mouse is inside of a rectangle
function mouseInside(mouseX, mouseY, rectX, rectY, rectWidth, rectHeight)
	if mouseX > rectX and mouseX < (rectX + rectWidth) and mouseY > rectY and mouseY < (rectY + rectHeight) then
		return true
	else return false end
end

--returns true if the table t is empty
function isEmpty(t)
	local empty = false
	if next(t) == nil then empty = true end
	return empty
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

--implementation of some useful algorithms

--fisher-yates 
--shuffles a table t
--remember to use pairs not iparis
function shuffle(t)
	local result = copyTable(t)
	for i = #result, 2, -1 do 
		local j = random(1, i)
		result[i], result[j] = result[j], result[i]
	end
	return result
end

function copyTable(t)
	local newTable = {}
	for i, item in pairs(t) do
		table.insert(newTable, item)
	end
	return newTable 
end

function random(a, b)
	local num = math.floor(lume.random(a, b+.9999))
	return num
end


--implmentations of some useful data structures

DataStructure = class("DataStructure")

function DataStructure:initialize()
	self.table = {}
end

function DataStructure:peek()
	return self.table[#self.table]
end

function DataStructure:isEmpty()
	isEmpty(self.table)
end

function DataStructure:empty()
	for i, item in ipairs(self.table) do
		self.table[i] = nil
	end
end

function DataStructure:update(dt)
	for i, item in ipairs(self.table) do
		item:update(dt)
	end
end

function DataStructure:drawOffset(offset_x, offset_y, firstTile_x, firstTile_y)
	for i, item in ipairs(self.table) do
		item:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	end
end


Stack = class("Stack", DataStructure)

function Stack:initialize()
	DataStructure.initialize(self)
end

function Stack:pop()
	table.remove(#self.table)
end

function Stack:push(item)
	table.insert(#self.table, item)
end


Queue = class("Queue", DataStructure)

function Queue:initialize()
	DataStructure.initialize(self)
end

function Queue:pop()
	table.remove(#self.table)
end

function Queue:push(item)
	table.insert(self.table, item)
end