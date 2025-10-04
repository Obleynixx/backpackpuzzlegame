extends Node
class_name SingleUseDB

@export var rules: Array[SingleUseData] = []

func GetRule(singleUseID: String, item: ItemData) -> SingleUseData:
	for r in rules:
		if r.singleUseId == singleUseID and r.input == item:
			return r
	return null
