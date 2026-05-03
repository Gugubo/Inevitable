extends Label

@export var item: GameState.Item


func _ready():
	GameState.inventory_changed.connect(_on_inventory_changed)
	_on_inventory_changed(item)


func _on_inventory_changed(changed_item: GameState.Item):
	if item == changed_item:
		text = "x" + str(GameState.inventory[item])
