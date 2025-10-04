extends Node
class_name InventoryModel

signal itemAdded
signal itemRemoved
signal itemsCombined
signal itemsSingleUsed
signal inventoryCleared

var rows := 3
var cols := 3
var cells: Array = []

@export var recipeDB: RecipeDB
@export var singleUseDB: SingleUseDB

func _ready() -> void:
	cells.resize(rows * cols)
	for i in cells.size():
		cells[i] = null

func AddItem(item: ItemData) -> bool:
	var idx := cells.find(null)
	if idx == -1: return false
	cells[idx] = item
	itemAdded.emit(item)
	print("item added " + item.displayName)
	CheckEmpty()
	return true
	
func RemoveAt(index: int):
	if index < 0 or index >= cells.size(): return
	var it : ItemData = cells[index]
	if it:
		cells[index] = null
		itemRemoved.emit(it)
		CheckEmpty()
		
func Combine(i: int, j: int) -> bool:
	var a : ItemData = cells[i]
	var b : ItemData = cells[j]
	if not a or not b or i == j: return false
	var out := recipeDB.GetRecipeData(a,b)
	if out == null: return false
	if a.consumable or out.overrideConsumableA: cells[i] = null
	if b.consumable or out.overrideConsumableB: cells[j] = null
	AddItem(out.output)
	itemsCombined.emit(a,b,out.output)
	return true

func SingleUse(i: int, singleUseId: String) -> bool:
	var item: ItemData = cells[i]
	if not item: return false
	var rule := singleUseDB.GetRule(singleUseId, item)
	if rule == null: return false
	if rule.consumesItem:
		cells[i] = null
		itemRemoved.emit(item)
	if rule.output:
		AddItem(rule.outputItem)
	itemsSingleUsed.emit(item,singleUseId,rule.output)
	CheckEmpty()
	return true
		
	
func CheckEmpty():
	if cells.all(func(c): return c == null):
		inventoryCleared.emit()
