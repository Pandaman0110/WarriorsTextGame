--some sort of animalhandler to handle all the animals and shit ad check with collision and stuff

Handler = class("Handler")

function Handler:initialize(clock)
	self.clock = clock
	self.messages = Array:new()
end

function Handler:handleMessage(message)
	message:print()
	message:logTime(self.clock)
	self.messages:insert(message)
end

function Handler:readMessageAt(index)
	self.messages:at(index):printDetails()
end

function Handler:getMessage(index)
	return self.messages:at(index)
end


Message = class("Message")

--for now we got attack and took damage
function Message:initialize(messagetype, sender, text, visible)
	self.type = messagetype
	self.sender = sender
	self.text = text
	self.visible = visible
	self.time = ""
end

function Message:print()
	if self.visible == true then print(self.text) end
end

function Message:printDetails()
	print("Sender: " .. self.sender)
	print("Type: " .. self.type)
	print("Time: " .. self.time)
	print("Text: " .. self.text)
end

function Message:type()
	return self.type
end

function Message:getSender()
	return self.sender
end

function Message:getText()
	return self.text
end

function Message:getTime()
	return self.time
end

--eventually add in the day and month and stuff
function Message:logTime(clock)
	self.time = clock:getGameTime()
end