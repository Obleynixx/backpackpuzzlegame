extends Node2D
@export var view : InventoryView
@export var firstItems : Array[ItemData] = []
func _ready() -> void:
	call_deferred("AfterReady")
func AfterReady():
	for i in firstItems.size():
		view.model.AddItem(firstItems[i])
