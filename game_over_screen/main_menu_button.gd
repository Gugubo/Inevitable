extends ButtonWithSound

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
