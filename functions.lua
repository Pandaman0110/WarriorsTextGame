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

function clearTextSettings()
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

Array = class("Array")

function Array:initialize()
	self.array = {}
end

function Array:peek()
	return self.array[#self.array]
end

function Array:size()
	return #self.array
end

function Array:isEmpty()
	isEmpty(self.array)
end

function Array:empty()
	for i, item in ipairs(self.array) do
		self.array[i] = nil
	end
end

function Array:update(dt)
	for i, item in ipairs(self.array) do
		item:update(dt)
	end
end

function Array:drawOffset(offset_x, offset_y, firstTile_x, firstTile_y)
	for i, item in ipairs(self.array) do
		item:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	end
end


Stack = class("Stack", Array)

function Stack:initialize()
	Array.initialize(self)
end

function Stack:pop()
	local item = table.remove(self.table)
	return item
end

function Stack:push(item)
	table.insert(self.table, #self.table, item)
end

Queue = class("Queue", Array)

function Queue:initialize()
	Array.initialize(self)
end

function Queue:pop()
	local item = table.remove(self.table)
	return item
end

function Queue:push(item)
	table.insert(self.table, item)
end





Map = class("Map")

function Map:initialize()
	self.map = {}
end

function Map:insert(key, item)
	self.map[key] = item 
end

function Map:remove(key)
	self.map[key] = nil
end

function Map:count(item)
	for key, _item in pairs(self.map) do
		if _item == item then return true end
	end
	return false
end

Set = class("Set", Map)

function Set:initialize()
	Map.initialize(self)
end

function Set:insert(item)
	self.map[item] = true 
end

function Set:remove(item)
	self.map[item] = false 
end

function Set:count(item)
	return self.map[item]
end

function Set:size()
	local i = 0
	for key in pairs(self.map) do
		if key then i = i + 1 end
	end
	return i 
end

Node = class("Node")

function Node:initialize()

end

