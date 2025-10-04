extends Node
class_name RecipeDB
@export var recipes: Array[RecipeData] = []

func GetOutput(a: ItemData, b: ItemData) -> ItemData:
	for r in recipes:
		if (r.inputA == a and r.inputB == b) or (r.inputA == b and r.inputB == a):
			return r.output
	return null
func GetRecipeData(a: ItemData, b: ItemData) -> RecipeData:
	for r in recipes:
		if (r.inputA == a and r.inputB == b) or (r.inputA == b and r.inputB == a):
			return r
	return null
