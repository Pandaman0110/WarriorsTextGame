--later on get the cat image here maybe

--[[
	self.symptoms = {
		["Heavy bleeding "] = false,
		["Bleeding "] = false,
		["Pale "] = false,
		["Faint "] = false,
		["Paralyzed "] = false,
		["Partially paralyzed "] = false,
		["Sluggish "] = false,
		["Completely numb "] = false,
		["Partially numb "] = false,
		["Slightly numb "] = false,
		["Serious fever "] = false,
		["Moderate fever "] = false,
		["Slight fever "] = false,
		["Dizzy "] = false,
		["Extreme pain "] = false,
		["Moderate pain "] = false,
		["Slight pain "] = false,
		["Stunned "] = false,
		["Overexerted "] = false,
		["Exhausted "] = false,
		["Tired "] = false,
		["Drowning "] = false,
		["Winded "] = false,
		["Cannot breathe "] = false,
		["Trouble breathing "] = false,
		["Dehydrated "] = false,
		["Thirsty"] = false,
		["Starving "] = false,
		["Hungry"] = false,
		["Very drowsy "] = false,
		["Drowsy "] = false,
		["Nauseous "] = false,
		["Vision lost "] = false,
		["Vision impaired "] = false,
		["Vision somewhat impaired "] = false,
		["Spilled (Popped out) "] = false,
		["Cannot stand "] = false,
		["Stand impaired "] = false,
		["Cannot grasp "] = false,
		["Grasp impaired "] = false,
		["Cannot fly "] = false,
		["Flight impaired "] = false,
		["Motor nerve severed "] = false,
		["Sensory nerve severed "] = false,
		["Major artery torn "] = false,
		["Artery torn "] = false,
		["Overlapping fracture "] = false,
		["Compound fracture "] = false,
		["Torn tendon "] = false,
		["Tendon strain "] = false,
		["Tendon bruise "] = false,
		["Torn ligament "] = false,
		["Ligament strain "] = false,
		["Ligament bruise "] = false,
		["Need setting "] = false,
		["Broken tissue"] = false,
		["Heavy damage "] = false,
		["Moderate damage "] = false,
		["Light damage "] = false,
		["Partially broken tissue "] = false,
		["Extreme pain "] = false,
		["Moderate pain "] = false,
		["Minor pain "] = false,
		["Extreme swelling "] = false,
		["Medium swelling "] = false,
		["Minor swelling "] = false,
		["Infection "] = false
	}
	]]


Body = class("Body")

function Body:initialize(bodyparts)
	self.pain = 0 
	self.max_pain = 150
	self.bleeding = 0
end

function Body:printAfflictions()
	for key, affliction in pairs (self.affliction) do
		if affliction then print(key) end
	end
end

function Body:update(dt)

end



CatBody = class("CatBody")

function CatBody:initialize()
	self.symptoms = {
		["Heavy bleeding"] = false,
		["Bleeding"] = false,
		["Pale"] = false,
		["Faint"] = false,
		["Paralyzed"] = false,
		["Partially paralyzed"] = false,
		["Sluggish"] = false,
		["Completely numb"] = false,
		["Partially numb"] = false,
		["Slightly numb"] = false,
		["Serious fever"] = false,
		["Moderate fever"] = false,
		["Slight fever"] = false,
		["Dizzy"] = false,
		["Stunned"] = false,
		["Overexerted"] = false,
		["Exhausted"] = false,
		["Tired"] = false,
		["Drowning"] = false,
		["Winded"] = false,
		["Cannot breathe"] = false,
		["Trouble breathing"] = false,
		["Dehydrated"] = false,
		["Thirsty"] = false,
		["Starving"] = false,
		["Hungry"] = false,
		["Very drowsy"] = false,
		["Drowsy"] = false,
		["Nauseous"] = false,
		["Vision lost"] = false,
		["Vision impaired"] = false,
		["Vision somewhat impaired"] = false,
		["Spilled (Popped out)"] = false,
		["Cannot stand"] = false,
		["Stand impaired"] = false,
		["Cannot grasp"] = false,
		["Grasp impaired"] = false,
		["Cannot fly"] = false,
		["Flight impaired"] = false,
		["Motor nerve severed"] = false,
		["Sensory nerve severed"] = false,
		["Major artery torn"] = false,
		["Artery torn"] = false,
		["Overlapping fracture"] = false,
		["Compound fracture"] = false,
		["Torn tendon"] = false,
		["Tendon strain"] = false,
		["Tendon bruise"] = false,
		["Torn ligament"] = false,
		["Ligament strain"] = false,
		["Ligament bruise"] = false,
		["Need setting"] = false,
		["Broken tissue"] = false,
		["Heavy damage"] = false,
		["Moderate damage"] = false,
		["Light damage"] = false,
		["Partially broken tissue"] = false,
		["Extreme swelling"] = false,
		["Medium swelling"] = false,
		["Minor swelling"] = false,
		["Infection"] = false
	}

	self.head = Head:new()
	self.neck = Neck:new()
	self.upper_body = UpperBody:new()
	self.lower_body = LowerBody:new()
	self.tail = Tail:new()
	self.front_right_leg = Leg:new()
	self.front_left_leg = Leg:new()
	self.back_right_leg = Leg:new()
	self.back_left_leg = Leg:new()

	-----------------
	
	self.weight = 10

	--in mL
	self.blood = 500

	self.bleeding = 0

	self.pain = 0 
	self.max_pain = 150

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
		["Minor"] = false,
		["Inhibited"] = false,
		["Function Loss"] = false,
		["Broken"] = false,
		["Missing"] = false
	}
	self.bones = {
	}
	self.tissue = {}

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
		["Skull"] = Bone:new(),
		["Teeth"] = Bone:new()
	}
	self.organs = {
		["Brain"] = Brain:new(),
		["Left Eye"] = Eye:new(),
		["Right Eye"] = Eye:new(),
		["Left Ear"] = Ear:new(),
		["Right Ear"] = Ear:new(),
		["Nose"] = Nose:new()
	}
end


Neck = class("Neck", BodyPart)

function Neck:initialize()
	BodyPart.initialize(self)
	self.bones = {
		["Neck"] = Bone:new()
	}
	self.organs = {
		["Throat"] = Throat:new()
	}

end




UpperBody = class("Chest", BodyPart)

function UpperBody:initialize()
	BodyPart.initialize(self)
	self.bones = {
		["Ribcage"] = Bone:new(),
		["Upper Spine"] = Bone:new()
	}
	self.organs = {
		["Heart"] = Heart:new(),
		["Left Lung"] = Lung:new(), 
		["Right Lung"] = Lung:new()
	}
end



LowerBody = class("LowerBody", BodyPart)

function LowerBody:initialize()
	BodyPart.initialize(self)
	self.bones = {
		["Lower Spine"] = Bone:new()
	}
	self.organs = {
		["Stomach"] = Stomach:new(),
		["Guts"] = Guts:new()
	}
end




Leg = class("Leg", BodyPart)

function Leg:initialize()
	BodyPart.initialize(self)
	self.bones = {
		["Upper Leg"] = Bone:new(),
		["Lower Leg"] = Bone:new(),
		["Foot"] = Bone:new()
	}
end


Tail = class("Tail", BodyPart)

function Tail:initialize()
	BodyPart.initialize(self)
	self.bones = {
		["Tail"] = Bone:new()
	}
end


local status_max = 100


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

function SubPart:getActiveStatus()
	local status = {}
	for key, status in pairs (self.status) do
		if status then 
			status[key] = true 
		end
	end
	return status
end

function SubPart:printActiveStatus()

end

Fur = class("Fur", SubPart)

function Fur:initialize()
	SubPart.initialize(self)
	--Normal / burned / standing / torn / bloody
	self.status = {
		["Burn"] = status_max,
		["Torn"] = status_max, 
		["Bloody"] = status_max
	}
end

function Fur:printActiveStatus(part)
	local active_status = self:getActivesStatus()
	for key, status in pairs (active_status) do
		print()
	end

end


Bone = class("Bone", SubPart)

function Bone:initialize()
	SubPart.initialize(self)
	self.status = {
		["Fractured"] = false,
		["Broken"] = false
	}
end






--both skin and muscle
Tissue = class("Tissue", SubPart)

function Tissue:initialize()
	SubPart.initialize(self)
	self.skin = {

	}
end







Organ = class("Organ", SubPart)

function Organ:initialize()
	SubPart.initialize(self)
end

function Organ:update(dt)

end





Guts = class("Guts", Organ)

function Guts:initialize()
	Organ.initialize(self)
end

Throat = class("Throat", Organ)

function Throat:initialize()
	Organ.initialize(self)
end

Lung = class("Lung", Organ)

function Lung:initialize()
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

Ear = class("Ear", Organ)

function Ear:initialize()
	Organ.initialize(self)
end

Eye = class("Eye", Organ)

function Eye:initialize()
	Organ.initialize(self)
end

Nose = class("Nose", Organ)

function Nose:initialize()
	Organ.initialize(self)
end





Skin = class("Skin", Organ)