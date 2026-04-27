extends Control

@onready var animation_player = $AnimationPlayer
@onready var time_label = $CenterContainerTime/TimeLabel
@onready var game_over_sfx = $GameOverSFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.game_end.connect(_on_game_end)


func _on_game_end() -> void:
	visible = true
	animation_player.play("show")
	
	game_over_sfx.play()

	time_label.text = format_time(GameState.timer)


func format_time(seconds: float) -> String:
	var sec = int(seconds)
	var h = sec / 3600
	var m = (sec % 3600) / 60
	var s = sec % 60
	
	return "%d:%02d:%02d" % [h, m, s]
