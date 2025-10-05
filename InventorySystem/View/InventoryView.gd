extends Control
class_name InventoryView

@export var modelN: NodePath
@export var slotsContainer: NodePath
#@export var slotScene: PackedScene
var model : InventoryModel
var slots : Array[InventorySlot] = []
var selectedIndex := -1

signal onInventoryCleared

func _ready() -> void:
	model = get_node(modelN) as InventoryModel
	BuildOrBindSlots()
	BindModelSignals()
	RefreshAll()

func BuildOrBindSlots():
	var container := get_node(slotsContainer)
	slots.clear()
	
	for i in container.get_child_count():
		var slot = container.get_child(i)
		BindSlot(slot,i)
		slots.append(slot)
		
func BindSlot(slot: InventorySlot, index: int):
	slot.index = index
	slot.pressed.connect(func(): OnSlotPressed(index))
	slot.droppedOnSlot.connect(func(sourceIndex: int): OnSlotDrop(sourceIndex, index))
	slot.requestItemAtIndex.connect(func(idx:int) -> ItemData:
		return model.cells[idx] if idx >= 0 and idx < model.cells.size() else null)
	slot.queryCombineValid.connect(func(sourceIndex: int,targetIndex: int) -> bool:
		var a: ItemData = model.cells[sourceIndex]
		var b: ItemData = model.cells[targetIndex]
		if not a or not b or sourceIndex == targetIndex:
			return false
		return model.recipeDB.GetOutput(a,b) != null)
func BindModelSignals():
	model.itemAdded.connect(func(it): RefreshAll())
	model.itemRemoved.connect(func(it): RefreshAll())
	model.itemsCombined.connect(func(a,b,recipe): RefreshAll())
	model.itemsSingleUsed.connect(func(it,id,rule): RefreshAll())
	model.inventoryCleared.connect(func():
		OnInventoryCleared()
		onInventoryCleared.emit())
	
func RefreshAll():
	for i in slots.size():
		var it: ItemData = model.cells[i]
		slots[i].SetItem(it)
		slots[i].SetSelected(i == selectedIndex)
		
func OnSlotPressed(index: int):
	if selectedIndex == -1:
		selectedIndex = index
		RefreshAll()
		return
	
	if index != selectedIndex:
		var ok := model.Combine(selectedIndex,index)
		Feedback(ok)
		selectedIndex = -1
		RefreshAll()
	else:
		selectedIndex = -1
		RefreshAll()

func OnSlotDrop(sourceIndex: int, targetIndex: int):
	var ok := model.Combine(sourceIndex,targetIndex)
	Feedback(ok)
	selectedIndex = -1
	RefreshAll()

func OnInventoryCleared():
	print("Inventory Cleared!")

func Feedback(success: bool):
	#do something when true or false to identify if there are recipes or not with this
	return
func AttemptSingleUse(singleUseID: String):
	if selectedIndex == -1:
		return
	var ok := model.SingleUse(selectedIndex,singleUseID)
	Feedback(ok)
	selectedIndex = -1
	RefreshAll()
	
func AttemptSingleUseFromIndex(sourceIndex: int, singleUseID: String):
	var ok := model.SingleUse(sourceIndex, singleUseID)
	Feedback(ok)
	selectedIndex = -1
	RefreshAll()
