extends TextureButton

@export var title_screen_scene: PackedScene

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
