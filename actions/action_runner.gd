class_name ActionRunner
extends Node

signal action_completed

var action: Action
var _timer: SceneTreeTimer

var population: Population
var workers: Array[Citizen] = []


func _ready():
	population = get_tree().current_scene.get_node("Population")


func start(new_action: Action) -> void:
	action = new_action
	
	# Remove items from inventory
	GameState.consume_items(action.required_items)
	
	# Remove idle population
	GameState.work(action.required_population)
	
	workers = population.get_workers(action.required_population, action.work_area)
	
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
		var morale_factor = smoothstep(0.0, 1.0, sqrt(GameState.morale / 100.0))
		var amount = max(gathered_loot[item] * morale_factor, 1)
		GameState.add_item(item, amount)
	
	# Add to idle population again
	GameState.feierabend(action.required_population)
	
	population.free_workers(workers)
	
	# Update other effects
	GameState.add_morale(action.morale)
	GameState.add_corruption(action.corruption)
	GameState.add_population(action.population_change)
	
	if action.population_change < 0:
		population.sacrifice(workers)
	elif action.population_change > 0:
		for i in range(action.population_change):
			population.add_citizen()
	
	action_completed.emit()
	
	# Cease to exist
	queue_free()
