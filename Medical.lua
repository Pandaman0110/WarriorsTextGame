--later on get the cat image here maybe

CatBody = {

}

Body = class("Body")

function Body:initialize(bodyparts)

end

function Body:update(dt)

end

function Body:getHead()
	return self.head
end

function Body:getNeck()
	return self.neck
end

CatBody = class("CatBody")

function CatBody:initialize()
	self.head = Head:new()
	self.neck = Neck:new()
	self.chest = Chest:new()
	self.belly = Belly:new()
	self.back = Back:new()
	self.tail = Tail:new()
	self.front_right_leg = Leg:new()
	self.front_left_leg = Leg:new()
	self.back_right_leg = Leg:new()
	self.back_left_leg = Leg:new()

	-----------------
	
	self.weight
	self.blood = 500




end

function CatBody:update(dt)

end

function CatBody:setWeight(weight)
	self.weight = weight
end



BodyPart = class("BodyPart")


function BodyPart:initialize()
	--None / Minor / Inhibited / Function Loss /  Broken / Missing
	self.function_status = {
		["None"] = true
		["Minor"] = false
		["Inhibited"] = false
		["Function Loss"] = false
		["Broken"] = false
		["Missing"] = false
	}
	self.bones = {}
end

function BodyPart:update(dt)

end

function BodyPart:getFunction()
	return self.function_status
end

function BodyPart:getBones()
	return self.bones 
end


Head = class("Head", BodyPart)

function Head:initialize()
	BodyPart.initialize(self)
	self.bones = {
		["Skull"] = Bone:new()
		["Teeth"] = Bone:new()
	}
	self.organs = {
		["Brain"] = Brain:new()
		["Eyes"] = Eyes:new()
		["Ears"] = Ears:new()
		["Nose"] = Nose:new()
	}
end


Neck = class("Neck", BodyPart)

function Neck:initialize()
	BodyPart.initialize(self)
	self.bones = {
		["Neck"] = Bone:new()
	}

end




Chest = class("Chest", BodyPart)

function Chest:initialize()
	BodyPart.initialize(self)
end




Belly = class("Belly", BodyPart)

function Belly:initialize()
	BodyPart.initialize(self)
end





Back = class("Back", BodyPart)

function Back:initialize()
	BodyPart.initialize(self)
end




Leg = class("Leg", BodyPart)

function Leg:initialize()
	BodyPart.initialize(self)
end




Tail = class("Tail", BodyPart)

function Leg:initialize()
	BodyPart.initialize(self)
end






--subparts
SubPart = class("SubPart")

function SubPart:initialize()
	self.status = {}
end

function SubPart:updateStatus()
	for key, status in pairs(self.status) do 
		if key ~= "Normal" and status == true then 
			self.status["Normal"] = false
		end
	end
end

function SubPart:getStatus()
	local status = {}
	for key, status in pairs (self.status) do
		if status == true then 
			status[key] = true 
		end
	end
	return status
end

function SubPart:printStatus()



Fur = class("Fur", SubPart)

function Fur:initialize()
	SubPart.initialize(self)
	--Normal / burned / standing / torn / bloody
	self.status = {
		["Normal"] = true, 
		["Standing"] = false,
		["Burned"] = false, 
		["Torn"] = false, 
		["Bloody"] = false, 
	}
end


Bone = class("Bone", SubPart)

function Bone:initialize()
	SubPart.initialize(self)
	self.status = {
		["Normal"] = true
		["Fractured"] = false 
		["Broken"] = false
	}
end






--both skin and muscle
Tissue = class("Tissue", SubPart)

function Tissue:initialize()
	SubPart.initialize(self)
end







Organ = class("Organ", SubPart)

function Organ:initialize()
	SubPart.initialize(self)
end

function Organ:update(dt)

end



Lungs = class("Lungs", Organ)

function Lungs:initialize()
	Organ.initialize(self)
end

Heart = class("Heart", Organ)

function Heart:initialize()
	Organ.initialize(self)
end

Liver = class("Liver", Organ)

function Liver:initialize()
	Organ.initialize(self)
end

Stomach = class("Stomach", Organ)

function Stomach:initialize()
	Organ.initialize(self)
end

Brain = class("Brain", Organ)

function Brain:initialize()
	Organ.initialize(self)
end

Ears = class("Ears", Organ)

function Ears:initialize()
	Organ.initialize(self)
end

Eyes = class("Eyes", Organ)

function Eyes:initialize()
	Organ.initialize(self)
end

Nose = class("Nose", Organ)

function Nose:initialize()
	Organ.initialize(self)
end