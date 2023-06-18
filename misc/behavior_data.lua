
Actions = {
	["MoveTo"] = MoveTo:new()
	["CheckDistanceToPlayer"] = DistanceToPlayer:new()
}




AnimalSubTrees = {


}

CatSubTrees = {
	["Follow Player"] = {
		--check if player is within 10 tiles
		--check if there is a valid path to player
		--move towards player
		--stop when you get within 1 tile of the player
	}
}



CatBehaviorTree = 
{	
	["Root"] = {
		["Follow Player"] = {
			--check if player is within 10 tiles
			--check if there is a valid path to player
			--move towards player
			--stop when you get within 1 tile of the player
		}



	}
}