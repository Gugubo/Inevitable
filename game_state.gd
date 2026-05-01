extends Node

enum Item { WOOD, STONE, FOOD, TOOLS }
enum State { MENU, PLAYING, GAME_OVER }

signal inventory_changed(item: Item)
signal population_changed
signal morale_changed
signal game_end
signal restart

var MAX_ITEM_COUNT = 999
var MAX_POPULATION = 999

var total_population = 0
var idle_population = 0
var morale = 0.0 # 0 - 100
var corruption = 0.0 # 0 - 100

var corruption_speed = 1
var corruption_acceleration = 0.012

var corruption_game_over_period = 10
var corruption_game_over_timer = 0

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

var state = State.MENU

var timer = 0.0

func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	corruption = clampf(corruption + delta * corruption_speed, 0, 100)
	corruption_speed += delta * corruption_acceleration
	
	if corruption >= 100:
		corruption_game_over_timer += delta
		if corruption_game_over_timer >= corruption_game_over_period:
			game_over()
	else:
		corruption_game_over_timer = 0
	
	# Increase Timer
	if state == State.PLAYING:
		timer += delta


func reset() -> void:
	total_population = 30
	idle_population = total_population
	
	morale = 80.0
	corruption = 0.0
	corruption_speed = 1.0
	
	inventory = {
		Item.WOOD: 25,
		Item.STONE: 25,
		Item.FOOD: 25,
		Item.TOOLS: 30,
	}
	
	state = State.PLAYING
	
	timer = 0.0
	
	for item in inventory:
		inventory_changed.emit(item)
	population_changed.emit()
	morale_changed.emit()
	
	restart.emit()


func add_item(item: Item, amount: int) -> void:
	inventory[item] += amount
	inventory[item] = clamp(inventory[item], 0, MAX_ITEM_COUNT)
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
	morale = clampf(morale + morale_delta, 0, 100)
	morale_changed.emit(morale)


func add_corruption(corruption_delta: float) -> void:
	corruption = clampf(corruption + corruption_delta, 0, 100)


func add_population(population_delta: int) -> void:
	if population_delta == 0:
		return
	
	# Handle max population
	var new_total_population = clamp(total_population + population_delta, 0, MAX_POPULATION)
	var population_added = new_total_population - total_population
	
	total_population += population_added
	idle_population += population_added
	
	if total_population <= 0:
		game_over()
	
	population_changed.emit()


func game_over() -> void:
	if state == State.GAME_OVER:
		return
	
	state = State.GAME_OVER
	
	game_end.emit()
	
	morale = 0
	morale_changed.emit(0)


func get_corruption_factor() -> float:
	return clamp(corruption / 100.0, 0, 1)
