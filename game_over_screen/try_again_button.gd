extends ButtonWithSound

@onready var game_over_screen = $"../../.."


func _on_pressed() -> void:
	GameState.reset()
	game_over_screen.animation_player.play("RESET")
	game_over_screen.visible = false
