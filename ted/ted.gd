extends Node2D

@onready var small_eyes: Array[SmallEye] = [$SmallEye1, $SmallEye2, $SmallEye3, $SmallEye4]
@onready var eyelid = $Eyelid

## Position on no corruption
@export var y_no_corruption = 100

## Position on full corruption
@export var y_full_corruption = 0

## Corruption factor when eyelid starts to open
@export var eyelid_open = 0.8

## Corruption factor when small eyes starts to open
@export var small_eyes_open = 0.8

var target_y = y_no_corruption
var speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = y_no_corruption


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate target based on current corruption
	target_y = lerpf(y_no_corruption, y_full_corruption, GameState.get_corruption_factor())
	
	# Move to target
	position.y = lerpf(position.y, target_y, speed * delta)
	
	# Update eyes
	_update_eyelid()
	_update_small_eyes()


func _update_eyelid() -> void:
	var eyelid_factor = (GameState.get_corruption_factor() - eyelid_open) / (1.0 - eyelid_open)
	eyelid.frame = floor(eyelid_factor * 5.0)


func _update_small_eyes() -> void:
	if GameState.get_corruption_factor() >= small_eyes_open:
		_open_small_eyes()
	else:
		_close_small_eyes()


func _open_small_eyes() -> void:
	for eye in small_eyes:
		if not eye.is_open:
			eye.open()


func _close_small_eyes() -> void:
	for eye in small_eyes:
		if eye.is_open:
			eye.close()
