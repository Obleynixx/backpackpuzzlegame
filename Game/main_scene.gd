extends Node2D
@export var view : InventoryView
@export var firstItems : Array[ItemData] = []

@export_file("*.tscn") var next_scene_path: String
#This is bs packedscenes gets deleted?? or nulified out of nowhere wtf
#@export var nextScene : PackedScene

func _ready() -> void:
	call_deferred("AfterReady")
	view.onInventoryCleared.connect(OnCleared,CONNECT_ONE_SHOT)
func AfterReady():
	for i in firstItems.size():
		view.model.AddItem(firstItems[i])

func OnCleared() -> void:
	#Do some feedback first like fading out to black and playing a correct sound in inventory view
	print("should be changing levels")
	get_tree().change_scene_to_file(next_scene_path)
