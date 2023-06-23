local nodes = {
	["Sequence"] = Sequence,
	["Fallback"] = Fallback,
	["LookAround"] = LookAround,
}

CatBehaviorTree = {	
	{nodes["Sequence"],
		{nodes["LookAround"]},
		{nodes["Sequence"]}
	}
}




--lets make an attack tare=get ciomposite trere