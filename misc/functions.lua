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

function Array:initialize(size)
	self.array = {}
	if size then 
		for i = 1, size do
        	t[i] = i
    	end
	end
end

function Array:iterator(index)
	if index then assert(type(index) == "number", "cannot index array with type: " .. type(index) .. " please use number") end
	if index then assert(not self.array[index], "value: " .. index .. " is not a valid index") end
	local i = 0
	if index then i = index end
	local n = table.getn(self.array)
	return function()
		i = i + 1
		if i <= n then return self.array[i] end 
	end
end

function Array:remove(...)
	local removed = {}
	for i, v in ipairs(arg) do
		if type(v) == "number" then 
			table.insert(removed, table.remove(self.array, v))
		else 
			for j, thing in ipairs(self.array) do
				if thing == v then 
					table.insert(removed, table.remove(self.array, j))
				end
			end
		end
	end
	if #removed > 0 then return true, removed 
	else return false, removed end
end

function Array:insert(item, index)
	if index then assert(type(index) == "number", "cannot index array with type: " .. type(index) .. " please use number") end
	if index then table.insert(self.array, index, item) else
		table.insert(self.array, item)
	end
end 

function Array:randomChoice()
	return lume.randomchoice(self.array)
end

function Array:peek()
	return self.array[#self.array]
end

function Array:size()
	return #self.array
end

function Array:find(item)
	for i, thing in ipairs(self.array) do
		if thing == item then return i end
	end
	return false
end

function Array:at(index)
	assert(type(index) == "number", "cannot index array with type: " .. type(index) .. " please use number")
	return self.array[index]
end

function Array:contains(item)
	for i, thing in ipairs(self.array) do
		if thing == item then return true end
	end
	return false
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
	local item = table.remove(self.array)
	return item
end

function Stack:push(item)
	table.insert(self.array, #self.array, item)
end




Queue = class("Queue", Array)

function Queue:initialize()
	Array.initialize(self)
end

function Queue:pop()
	local item = table.remove(self.array)
	return item
end

function Queue:push(item)
	table.insert(self.array, item)
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


Graph = class("Graph")

function Graph:initialize()
	self.vertexes = Array:new()
	self.graph = {{}}
end

function Graph:addVertexPair(vertex_1, vertex_2)
	assert(not self.vertexes:contains(vertex_1), "graph already contains: " .. vertex_1)
	assert(not self.vertexes:contains(vertex_2), "graph already contains: " .. vertex_2)
	self.vertexes:insert(vertex_1)
	self.vertexes:insert(vertex_2)
end

function Graph:addEdge(vertex_1, vertex_2, edge)
	assert(self.vertexes:contains(vertex_1) or self.vertexes:contains(vertex_2), "please add the vertex first before using it to connect an edge")
	local ver1, ver2 = self.vertexes:find(vertex_1), self.vertexes:find(vertex_2)
	assert(self.graph[ver1][ver2] == nil, "there is already an edge between these two vertices")
	self.graph[ver1][ver2] = edge
end 

function Graph:removeEdge(edge)
	for vertex_1, row in pairs(self.graph) do
		for vertex_2, _edge in pairs(row) do
			if _edge == edge then  self.graph[vertex_1][vertex_2] = nil end
		end
	end
end

function Graph:getEdge(vertex_1, vertex_2)
	local ver1, ver2 = self.vertexes:find(vertex_1), self.vertexes:find(vertex_2)
	return self.graph[ver1][ver2]
end
