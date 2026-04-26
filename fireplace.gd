extends AnimatedSprite2D

@onready var animation_player = $AnimationPlayer


func _ready() -> void:
	GameState.game_end.connect(_on_game_end)


func _on_game_end() -> void:
	extinguish()


func extinguish() -> void:
	animation_player.play("extinguish")
	animation = "unlit"
