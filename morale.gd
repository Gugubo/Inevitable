extends Sprite2D

var min_frame = 5
var number_of_states = 5

enum MoraleState { DEAD, DESPAIRING, SAD, NEUTRAL, HAPPY, EUPHORIC }
var state = MoraleState.EUPHORIC

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.morale_changed.connect(_on_morale_changed)
	_on_morale_changed() # Update at the start


func _on_morale_changed() -> void:
	var morale = GameState.morale
	var morale_index = floor((clampf(morale, 0, 100) / 100.0) * number_of_states)
	var new_state = MoraleState.DEAD if morale <= 0 else MoraleState.values()[morale_index]
	
	if state != new_state:
		state = new_state
		frame = state + min_frame
		_jump_tween()


func _jump_tween() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "offset", Vector2(0, -2), 0.2)
	tween.tween_property(self, "offset", Vector2(0, 0), 0.2)
