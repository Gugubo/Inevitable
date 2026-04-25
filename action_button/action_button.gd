class_name ActionButton
extends TextureButton

@export var action: Action

func _ready() -> void:
	GameState.inventory_changed.connect(_on_inventory_changed)
	
	update_state()


func _on_inventory_changed(item: GameState.Item) -> void:
	update_state()


func _on_pressed() -> void:
	# Make sure we have the required items
	if not GameState.has_items(action.required_items):
		return
	
	# Add runner
	var runner = ActionRunner.new()
	add_child(runner)
	runner.action_completed.connect(_on_completed)
	runner.start(action)
	
	update_state()


func _on_completed(loot: Dictionary[GameState.Item, int]) -> void:
	update_state() # Not really needed because inventory change already triggers an update


func update_state() -> void:
	disabled = not GameState.has_items(action.required_items)
