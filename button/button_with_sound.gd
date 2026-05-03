class_name ButtonWithSound
extends TextureButton

@onready var down_sfx = $ButtonDownSFX
@onready var up_sfx = $ButtonUpSFX


func _on_button_down() -> void:
	down_sfx.play()


func _on_button_up() -> void:
	up_sfx.play()
