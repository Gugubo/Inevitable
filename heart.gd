extends AnimatedSprite2D

@export var min_bpm = 60
@export var max_bpm = 210


func _process(delta: float) -> void:
	if GameState.state == GameState.State.GAME_OVER:
		stop()
	
	var bpm = lerp(min_bpm, max_bpm, GameState.get_corruption_factor())
	speed_scale = bpm/min_bpm
