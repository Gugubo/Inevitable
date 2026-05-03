extends Node

@onready var sacrifice_button = $".."
@onready var sfx = $AppearSFX

@export var reveal_threshold = 0.85

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_reset()
	GameState.restart.connect(_reset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not sacrifice_button.visible and GameState.get_corruption_factor() >= reveal_threshold:
		_show()


func _reset():
	sacrifice_button.visible = false


func _show():
	sacrifice_button.visible = true
	sfx.play()
	_spawn_tween()


func _spawn_tween() -> void:
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(sacrifice_button, "modulate:a", 1.0, 2.5).from(0.0)
	tween.parallel().tween_property(sacrifice_button, "scale:y", 1.0, 2.5).from(1.2)
