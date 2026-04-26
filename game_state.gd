extends Node

enum Item { WOOD, STONE, FOOD, TOOLS }

signal inventory_changed(item: Item)
signal population_changed
signal morale_changed(morale: float)

var total_population = 0
var idle_population = 0
var morale = 0.0 # 0 - 100
var corruption = 0.0 # 0 - 100

var corruption_speed = 1.0
var corruption_acceleration = 0.001

var inventory: Dictionary[Item, int] = {
	Item.WOOD: 0,
	Item.STONE: 0,
	Item.FOOD: 0,
	Item.TOOLS: 0,
}
var item_labels: Dictionary[Item, String] = {
	Item.WOOD: "Wood",
	Item.STONE: "Stone",
	Item.FOOD: "Food",
	Item.TOOLS: "Tools",
}

func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	corruption = clampf(corruption + delta * corruption_speed, 0, 100)
	corruption_speed += delta * corruption_acceleration


func reset() -> void:
	total_population = 30
	idle_population = total_population
	
	morale = 100.0
	corruption = 0.0
	
	inventory = {
		Item.WOOD: 10,
		Item.STONE: 10,
		Item.FOOD: 15,
		Item.TOOLS: 15,
	}


func add_item(item: Item, amount: int) -> void:
	inventory[item] += amount
	inventory_changed.emit(item)


func has_items(requirements: Dictionary[Item, int]) -> bool:
	for item in requirements:
		if inventory.get(item, 0) < requirements[item]:
			return false
	return true


func consume_items(items: Dictionary[Item, int]) -> void:
	for item in items:
		inventory[item] -= items[item]
		inventory_changed.emit(item)


func has_idle_population(population_needed: int) -> bool:
	return idle_population >= population_needed


func work(workers: int) -> void:
	idle_population -= workers
	population_changed.emit()


func feierabend(workers: int) -> void:
	idle_population += workers
	population_changed.emit()


func add_morale(morale_delta: float) -> void:
	morale += morale_delta
	morale_changed.emit(morale)


func add_corruption(corruption_delta: float) -> void:
	corruption += corruption_delta


func add_population(population_delta: int) -> void:
	if population_delta == 0:
		return
	
	total_population += population_delta
	idle_population += population_delta
	
	if total_population <= 0:
		game_over()
	
	population_changed.emit()


func game_over() -> void:
	morale = 0
	morale_changed.emit(0)


func get_corruption_factor() -> float:
	return clamp(corruption / 100.0, 0, 1)
