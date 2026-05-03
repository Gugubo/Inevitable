class_name ResourceCount
extends HBoxContainer

@onready var texture_rect = $TextureRect
@onready var label = $Label

@export var icon: Icon
@export var count = 0

enum Icon { POPULATION, TOOLS, FOOD, WOOD, STONE }

@export var textures: Dictionary[Icon, Texture2D] = {
	Icon.POPULATION: null,
	Icon.TOOLS: null,
	Icon.FOOD: null,
	Icon.WOOD: null,
	Icon.STONE: null,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.texture = textures[icon]
	label.text = str(count)
