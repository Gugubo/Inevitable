class_name ActionRunner
extends Node

signal action_completed

var action: Action
var _timer: SceneTreeTimer

func start(new_action: Action) -> void:
	action = new_action
	
	# Remove items from inventory
	GameState.consume_items(action.required_items)
	
	# Remove idle population
	GameState.work(action.required_population)
	
	# Create timer
	_timer = get_tree().create_timer(action.duration)
	_timer.timeout.connect(_on_complete)


func _on_complete() -> void:
	var gathered_loot: Dictionary[GameState.Item, int]
	
	# Roll loot
	for loot_item in action.loot:
		var amount = randi_range(loot_item.min_amount, loot_item.max_amount)
		if amount > 0:
			gathered_loot[loot_item.item] = amount
	
	# Add loot to inventory
	for item in gathered_loot:
		GameState.add_item(item, gathered_loot[item])
	
	# Add to idle population again
	GameState.feierabend(action.required_population)
	
	# Update other effects
	GameState.add_morale(action.morale)
	GameState.add_corruption(action.corruption)
	GameState.add_population(action.population_change)
	
	action_completed.emit()
	
	# Cease to exist
	queue_free()
