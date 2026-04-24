extends HBoxContainer

@export var item: GameState.Item

@onready var icon: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready():
	GameState.inventory_changed.connect(_on_inventory_changed)


func _on_inventory_changed(changed_item: GameState.Item):
	if item == changed_item:
		label.text = GameState.item_labels[item] + ": " + str(GameState.inventory[item])
