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

function Array:initialize(...)
	self.array = {} 
	if ... then 
		for i, item in ipairs(...) do self:insert(item) end
	end
end

function Array:iterator(index)
	if index then assert(type(index) == "number", "cannot index array with type: " .. type(index) .. " please use number") end
	if index then assert(self.array[index] ~= nil, "value: " .. index .. " is not a valid index") end

	local i = 0
	if index then i = index - 1 end
	local n = table.getn(self.array)

	return function()
		i = i + 1
		if i <= n then return i, self.array[i] end 
	end
end

function Array:riterator(index)
	if index then assert(type(index) == "number", "cannot index array with type: " .. type(index) .. " please use number") end
	if index then assert(self.array[index] ~= nil, "value: " .. index .. " is not a valid index") end

	local i = self:size() + 1
	if index then i = index + 1 end
	local n = table.getn(self.array)

	return function()
		i = i - 1
		if i >= 1 then return i, self.array[i] end 
	end
end

function Array:remove(...)
	local removed = {}
	for i, v in ipairs(...) do
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
		self.array[#self.array+1] = item
	end
end 

function Array:randomChoice()
	return lume.randomchoice(self.array)
end

function Array:peek()
	return self.array[#self.array]
end

function Array:size()
	return table.getn(self.array)
end

function Array:find(item)
	for i, thing in ipairs(self.array) do
		if thing == item then return i end
	end
	return false
end

function Array:at(index)
	--assert(type(index) == "number", "cannot index array with type: " .. type(index) .. " please use number")
	return self.array[index]
end

function Array:range(index_1, index_2)
	assert(type(index_1) == "number", "cannot index array with type: " .. type(index_1) .. " please use number")
	assert(type(index_2) == "number", "cannot index array with type: " .. type(index_2) .. " please use number")
	assert(self.array[index_1] ~= nil, "value: " .. index_1 .. " is not a valid index")
	assert(self.array[index_2] ~= nil, "value: " .. index_2 .. " is not a valid index")

	if index_1 <= index_2 then 
		local i = index_1 - 1
		local n = index_2
		return function()
			i = i + 1
			if i <= n then return self.array[i] end 
		end
	end
	if index_1 > index_2 then 
		local i = index_1 + 1
		local n = index_2
		return function()
			i = i - 1
			if i >= n then return i, self.array[i] end 
		end
	end
end

function Array:contains(item)
	for i, thing in ipairs(self.array) do
		if thing == item then return true end
	end
	return false
end

function Array:isEmpty()
	if table.getn(self.array) == 0 then return true else return false end
end

function Array:clear()
	for i, item in ipairs(self.array) do
		self.array[i] = nil
	end
end

function Array:get()
	return self.array
end

function Array:getRange(index_1, index_2)
	local new_table = {}
	for item in self:range(index_1, index_2) do
		table.insert(new_table, item)
	end
	return new_table
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

function Stack:initialize(...)
	Array.initialize(self)
	if ... then 
		for i, item in pairs(...) do self:push(item) end
	end
end

function Stack:pop()
	local item = table.remove(self.array, #self.array)
	return item
end

function Stack:push(item)
	table.insert(self.array, #self.array, item)
end

function Stack:insert(item, index)
	error("cannot insert into queue")
end

function Stack:remove(...)
	error("cannot remove from queue")
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

function Queue:insert(item, index)
	error("cannot insert into queue")
end

function Queue:remove(...)
	error("cannot remove from queue")
end

Map = class("Map")

function Map:initialize(...)
	self.map = {}
	if ... then 
		for key, value in pairs(...) do
		    self:insert(key, value)
		end
	end
end

function Map:iterator()
	return pairs(self.map)
end

function Map:at(key)
	return self.map[key]
end

function Map:get()
	return self.map 
end

function Map:insert(key, value)
	self.map[key] = value 
end

function Map:remove(key)
	self:checkType(key)
	self.map[key] = nil
end

function Map:count(value_1)
	for key, value_2 in pairs(self.map) do
		if value_1 == value_2 then return true end
	end
	return false
end

function Map:size()
	local i = 0
	for key, value in pairs(self.map) do
		i = i + 1
	end
	return i 
end

function Map:empty()
	for key, val in self:iterator() do
		self.map[key] = nil
	end
end

Graph = class("Graph")

function Graph:initialize(size)
	self.vertexes_1 = Array:new()
	self.vertexes_2 = Array:new()
	self.graph = {}
	for i = 1, size do
		self.graph[i] = {}
		for j = 1, size do
			self.graph[i][j] = nil
		end
	end
end

function Graph:iterator()
	local i = 0
	local graph_size = table.getn(self.graph)

	for vertex_1, row in pairs(self.graph) do
		local j = 0
		for vertex_2, edge in pairs(row) do
			local row_size = table.getn(row)
			return function()
				j = j + 1
				if j <= row_size then return row[j] end
			end
		end
		return function()
			i = i + 1
			if i <= graph_size then return self.graph[i] end
		end
	end
end

function Graph:addVertexPair(vertex_1, vertex_2)
	if not self.vertexes_1:contains(vertex_1) then self.vertexes_1:insert(vertex_1) end
	if not self.vertexes_2:contains(vertex_2) then self.vertexes_2:insert(vertex_2) end
end

function Graph:addEdge(vertex_1, vertex_2, edge)
	self:addVertexPair(vertex_1, vertex_2)
	local ver1, ver2 = self.vertexes_1:find(vertex_1), self.vertexes_2:find(vertex_2)
	self.graph[ver1][ver2] = edge
end 

function Graph:removeEdge(edge)
	for vertex_1, row in pairs(self.graph) do
		for vertex_2, _edge in pairs(row) do
			if _edge == edge then self.graph[vertex_1][vertex_2] = nil end
		end
	end
end

function Graph:getEdge(vertex_1, vertex_2)
	local ver1, ver2 = self.vertexes_1:find(vertex_1), self.vertexes_2:find(vertex_2)
	assert(ver1 or ver2, "not valid vertexes")
	return self.graph[ver1][ver2]
end

function Graph:touching(vertex_1)
	local ver1 = self.vertexes_1:find(vertex)
	if ver1 == false then return false end
	local edges = Array:new()
	for ver2, vertex_2 in self.vertexes_2:iterator() do
		print(ver1, ver2)
		edges:insert(self.graph[ver1][ver2])
	end
	return edges
end

function Graph:outgoing(vertex)
	local outgoing_vertexes = Array:new()
	for i, vertex_2 in self.vertexes_2:iterator() do 
		outgoing_vertexes:insert(self:getEdge(vertex, vertex_2))
	end
	return outgoing_vertexes
end

function Graph:incoming(vertex)
	local incoming_vertexes = Array:new()
	for i, vertex_1 in self.vertexes_1:iterator() do 
		incoming_vertexes:insert(self:getEdge(vertex_1, vertex))
	end
	return incoming_vertexes
end



StateMachine = class("StateMachine")

function StateMachine:initialize(...)
	self.states = {}
	self.state_stack = Stack:new()
end

function StateMachine:update(dt)
	self.state_stack:peek():update(dt)
end

function StateMachine:switchState()

end

function StateMachine:getState()


end

State = class("State") 

function State:initialize()

end

function State:update(dt) 

end
