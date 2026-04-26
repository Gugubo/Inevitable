class_name Population
extends Node2D

@onready var navigation_region = $Place

@export var citizen_scene: PackedScene

var citizens: Array[Citizen] = []

func _ready() -> void:
	await get_tree().create_timer(0.0001).timeout
	for i in range(GameState.total_population):
		add_citizen()


func add_citizen() -> void:
	var citizen = citizen_scene.instantiate() as Citizen
	citizens.append(citizen)
	
	var spawn_position = NavigationServer2D.region_get_random_point(navigation_region.get_rid(), 1, true)
	citizen.position = spawn_position
	
	add_child(citizen)


func _get_idle_citizens() -> Array[Citizen]:
	return citizens.filter(func (citizen: Citizen): return not citizen.busy)


func get_workers(n: int) -> Array[Citizen]:
	var workers = _get_idle_citizens().slice(0, n)
	for worker in workers:
		worker.set_busy(true)
	
	return workers


func free_workers(workers: Array[Citizen]) -> void:
	for worker in workers:
		worker.set_busy(false)
