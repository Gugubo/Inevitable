class_name SmallEye
extends AnimatedSprite2D

@onready var timer = $Timer

@export var blink_time_min = 5
@export var blink_time_max = 10

var is_open = false


func open() -> void:
	is_open = true
	_blink()


func close() -> void:
	is_open = false
	timer.stop()
	
	play("close")


func _start_blink_timer() -> void:
	timer.wait_time = randf_range(blink_time_min, blink_time_max)
	timer.start()


func _blink() -> void:
	if not is_open:
		return
	
	play("blink")
	_start_blink_timer()


func _on_timer_timeout() -> void:
	_blink()


func _on_area_2d_mouse_entered() -> void:
	if is_open:
		play("close")


func _on_area_2d_mouse_exited() -> void:
	if is_open:
		play("blink")
