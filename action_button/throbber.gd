extends TextureRect

@onready var animation_player = $AnimationPlayer

var duration: float

func _ready():
	animation_player.speed_scale = 1 / duration
	animation_player.current_animation = "loading"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
