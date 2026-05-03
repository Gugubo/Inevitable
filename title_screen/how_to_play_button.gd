extends TextureButton

@onready var main_menu = $"../.."
@onready var how_to_play = $"../../../HowToPlay"

func _on_pressed() -> void:
	main_menu.visible = false
	how_to_play.visible = true
