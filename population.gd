class_name Population
extends Node2D

@onready var place: NavigationRegion2D = $Place
@onready var forest: NavigationRegion2D = $Forest
@onready var mine: NavigationRegion2D = $Mine

@onready var work_area_to_region: Dictionary[Action.WorkArea, NavigationRegion2D] = {
	Action.WorkArea.PLACE: place,
	Action.WorkArea.FOREST: forest,
	Action.WorkArea.MINE: mine,
}

@export var citizen_scene: PackedScene

var citizens: Array[Citizen] = []

func _ready() -> void:
	GameState.game_end.connect(_on_game_over)
	GameState.restart.connect(_on_restart)
	reset()


func reset() -> void:
	await get_tree().create_timer(0.05).timeout
	for i in range(GameState.total_population):
		add_citizen()


func _on_restart() -> void:
	reset()


func add_citizen() -> void:
	var citizen = citizen_scene.instantiate() as Citizen
	citizens.append(citizen)
	
	var spawn_position = NavigationServer2D.region_get_random_point(place.get_rid(), 1, true)
	citizen.position = spawn_position
	
	add_child(citizen)
	
	citizen.set_area(place)


func _get_idle_citizens() -> Array[Citizen]:
	return citizens.filter(func (citizen: Citizen): return not citizen.busy)


func get_workers(n: int, work_area: Action.WorkArea) -> Array[Citizen]:
	var workers = _get_idle_citizens().slice(0, n)
	for worker in workers:
		worker.set_busy(true)
		worker.set_area(work_area_to_region[work_area])
	
	return workers


func free_workers(workers: Array[Citizen]) -> void:
	for worker in workers:
		worker.set_busy(false)
		worker.set_area(place)


func sacrifice(lambs: Array[Citizen]) -> void:
	for lamb in lambs:
		citizens.erase(lamb)
		lamb.ascend()


func _on_game_over() -> void:
	for citizen in citizens:
		citizen.ascend()
	citizens = []
