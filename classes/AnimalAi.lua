AnimalAi = class("AnimalAi")
	

function AnimalAi:initialize()
	self.behavior_tree = tree
end

function AnimalAi:update(dt)
	--self.behavior_tree:tick(dt)
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
