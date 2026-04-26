class_name Citizen
extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var agent = $NavigationAgent2D
@onready var timer = $Timer

@export var walk_speed = 5.0

var busy = false

var walking = false


func _ready():
	timer.start(randf_range(1, 10))


func set_busy(next_busy: bool) -> void:
	busy = next_busy
	sprite.speed_scale = 2 if busy else 1

	if busy:
		_stop_walking()
	else:
		timer.start()

func _start_walking() -> void:
	walking = true
	sprite.animation = "walking"


func _stop_walking() -> void:
	walking = false
	sprite.animation = "idle"
	timer.stop()


func _physics_process(_delta):
	if not walking:
		return

	# Navigation logic
	var next_path_pos = agent.get_next_path_position()
	var new_velocity = (next_path_pos - global_position).normalized() * walk_speed
	
	velocity = new_velocity
	move_and_slide()


func _set_new_random_target():	
	# Get random point on map
	var map_rid = get_world_2d().get_navigation_map()
	var random_point = NavigationServer2D.map_get_random_point(map_rid, 1, true)
	
	agent.target_position = random_point
	
	_start_walking()


func _on_timer_timeout() -> void:
	_set_new_random_target()


func _on_navigation_agent_2d_navigation_finished() -> void:
	if walking:
		_stop_walking()
		
		timer.start()
