AnimalAi = class("AnimalAi")
	
local behavior_tree_timer_val = 1

function AnimalAi:initialize()
	self.behavior_tree_timer = 1
end

function AnimalAi:update(dt)
	self.behavior_tree_timer = self.behavior_tree_timer - dt
end


CatController = class("CatController", AnimalController)

function CatController:initialize(animal, cathandler, game_handler, collision_map)
	AnimalController.initialize(self, animal, cathandler, game_handler, collision_map)
end



Idle = class("Idle", State)

function Idle:initialize()
	State.initialize(self)
end

function Idle:update(dt)

end

function Idle:getCurrentLocation()

end

Moving = class("Moving", State)

function Moving:initialize()
	State.initialize(self)
end
