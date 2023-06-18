local nodes = {
	["Sequence"] = Sequence:new(),
	["Selector"] = Selector:new(),
	["FindPath"] = FindPath:new(),
	["MoveTo"] = MoveTo:new(),
	["LookAround"] = LookAround:new(),
	["DistanceToCat"] = DistanceToCat:new()
}



CatBehaviorTree = {	
	[1] = {nodes["Sequence"], 
		[2] = {nodes["Sequence"],  
			nodes["LookAround"]
		}
		[3] = {}


		}
		--[1] = node_dictionary["Sequence"],
			--check if player is within 10 tiles
			--check if there is a valid path to player
			--move towards player
			--stop when you get within 1 tile of the playe
	}
}

