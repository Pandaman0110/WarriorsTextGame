--later on get the cat image here maybe

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

function CatBody:initialize(cat)
	self.cat = cat

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
	if self.cat:getMoons() <= 12 then 
		self.weight = 1/12 * 10
	else self.weight = 10 end

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
	--Normal / burned / standing / torn / bloody
	self.fur = {
		["Normal"] = true, 
		["Standing"] = false,
		["Burned"] = false, 
		["Torn"] = false, 
		["Bloody"] = false, 
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
end





Neck = class("Neck", BodyPart)

function Neck:initialize()
	BodyPart.initialize(self)
	self.bones
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

end






Fur = class("Fur", SubPart)

function Fur:initialize()
	SubPart.initialize(self)
end


Bone = class("Bone", SubPart)

function Bone:initialize()
	SubPart.initialize(self)
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