extends AnimatedSprite2D

@onready var animation_player = $AnimationPlayer


func extinguish() -> void:
	animation_player.play("extinguish")
	animation = "unlit"
