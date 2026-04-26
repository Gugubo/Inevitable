extends TextureButton

@onready var main_menu = $"../../../CenterContainer"
@onready var how_to_play = $"../.."

func _on_pressed() -> void:
	how_to_play.visible = false
	main_menu.visible = true
