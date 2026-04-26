class_name Citizen
extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var agent = $NavigationAgent2D
@onready var timer = $Timer

@export var walk_speed = 4.0
@export var run_speed = 10.0

var area: NavigationRegion2D

var busy = false
var walking = false


func set_busy(next_busy: bool) -> void:
	busy = next_busy
	sprite.speed_scale = 3 if busy else 1

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

	var speed = run_speed if busy else walk_speed

	# Navigation logic
	var next_path_pos = agent.get_next_path_position()
	var new_velocity = (next_path_pos - global_position).normalized() * speed
	
	velocity = new_velocity
	move_and_slide()


func _set_new_random_target():
	if not area:
		return
	
	# Get random point in area
	var random_point = NavigationServer2D.region_get_random_point(area.get_rid(), 1, true)
	
	agent.target_position = random_point
	
	_start_walking()


func set_area(new_area: NavigationRegion2D) -> void:
	area = new_area
	_stop_walking()
	_set_new_random_target()


func _on_timer_timeout() -> void:
	_set_new_random_target()


func _on_navigation_agent_2d_navigation_finished() -> void:
	if walking:
		_stop_walking()
	
	if not busy:
		timer.start()
