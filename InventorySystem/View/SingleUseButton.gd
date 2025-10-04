extends Button
class_name SingleUseButton

@export var singleUseID: String
@export var inventoryView: NodePath

var view: InventoryView

func _ready() -> void:
	view = get_node(inventoryView) as InventoryView
	pressed.connect(func(): view.AttemptSingleUse(singleUseID))

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("kind") and data.kind == "slot" and data.has("index")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if typeof(data) != TYPE_DICTIONARY: return
	view.AttempSingleUseFromIndex(int(data.index),singleUseID)
