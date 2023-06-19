local nodes = {
	["Sequence"] = Sequence:new(),
	["Selector"] = Selector:new(),
	["FindPath"] = FindPath:new(),
	["MoveTo"] = MoveTo:new(),
	["LookAround"] = LookAround:new(),
	["DistanceToCat"] = DistanceToCat:new()
}




CatBehaviorTree = {	
	{nodes["Sequence"], 
		{nodes["Sequence"],  
			nodes["LookAround"], 
			nodes["MoveTo"], 

		}
		--[1] = node_dictionary["Sequence"],
			--check if player is within 10 tiles
			--check if there is a valid path to player
			--move towards player
			--stop when you get within 1 tile of the playe
	}
}

