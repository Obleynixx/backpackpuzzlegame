extends Node
class_name InventoryModel

signal itemAdded
signal itemRemoved
signal itemsCombined(a: ItemData, b: ItemData, r: RecipeData)
signal itemsSingleUsed(it: ItemData, singleUseId: String, rule: SingleUseData)
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
	var r := recipeDB.GetRecipeData(a,b)
	if r == null: return false
	var consume_i := a.consumable \
		or ((a == r.inputA and r.overrideConsumableA) or (a == r.inputB and r.overrideConsumableB))
	var consume_j := b.consumable \
		or ((b == r.inputA and r.overrideConsumableA) or (b == r.inputB and r.overrideConsumableB))
	if consume_i: cells[i] = null
	if consume_j: cells[j] = null
	AddItem(r.output)
	if r.outputOptional != null:
		AddItem(r.outputOptional)
	itemsCombined.emit(a,b,r)
	CheckEmpty()
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
		AddItem(rule.output)
	itemsSingleUsed.emit(item,singleUseId,rule)
	CheckEmpty()
	return true
		
	
func CheckEmpty():
	if cells.all(func(c): return c == null):
		inventoryCleared.emit()
