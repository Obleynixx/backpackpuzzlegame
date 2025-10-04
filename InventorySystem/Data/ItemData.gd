extends Resource
class_name ItemData

@export var id: String
@export var displayName: String
@export var icon: Texture2D
@export var consumable := true
@export var tags : PackedStringArray = [] #things like flammable to check when making combinations
