extends Control

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.game_end.connect(_on_game_end)


func _on_game_end() -> void:
	visible = true
	animation_player.play("show")
