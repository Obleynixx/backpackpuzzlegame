extends Button
class_name InventorySlot

signal droppedOnSlot(sourceIndex: int) 
signal requestItemAtIndex(index: int)
signal queryCombineValid(sourceIndex: int, targetIndex: int)

@export var index := 0
@onready var iconTexture:TextureRect = $Icon
@onready var highlight: ColorRect = $Highlight

var item: ItemData = null

func SetItem(it: ItemData) -> void:
	item = it
	if it and it.icon == null:
		print("missing icon for " + it.displayName)
	if iconTexture:
		iconTexture.texture = it.icon if it else null
		modulate = Color.WHITE if it else Color (1,1,1,0.25)

func SetSelected(selected: bool) -> void:
	if highlight:
		highlight.visible = selected
		
func GetDragData(atPosition):
	if item == null:
		return null
	var preview := iconTexture.texture if iconTexture else null
	var data := {"kind": "slot", "index": index}
	set_drag_preview(MakePreview(preview))
	return data
		 
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY: return false
	if not data.has("kind") or data.kind != "slot": return false
	if not data.has("index"): return false
	var src := int(data.index)
	if src == index: return false
	var view: InventoryView = get_parent().get_parent()
	return view.model.recipeDB.GetOutput(
		view.model.cells[src],
		view.model.cells[index]
	) != null

func DropData(atPosition, data) -> void:
	if typeof(data) != TYPE_DICTIONARY: return
	if not data.has("index"): return
	droppedOnSlot.emit(int(data.index))

func MakePreview(tex: Texture2D):
	if tex == null: return null
	var c := TextureRect.new()
	c.texture = tex
	c.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	c.size = Vector2(48,48)
	return c
