extends Label

@export var item: GameState.Item

@export var color_normal = Color.WHITE
@export var color_low = Color.CRIMSON
@export var low_threshold = 5

func _ready():
	GameState.inventory_changed.connect(_on_inventory_changed)
	_on_inventory_changed(item)


func _on_inventory_changed(changed_item: GameState.Item):
	var count = GameState.inventory[item]
	
	if item == changed_item:
		text = "x" + str(count)
	
	modulate = color_low if count < low_threshold else color_normal
