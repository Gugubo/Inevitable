extends Label

@export var color_normal = Color.WHITE
@export var color_low = Color.CRIMSON
@export var low_threshold = 10

func _ready():
	GameState.population_changed.connect(_on_population_changed)
	_on_population_changed()


func _on_population_changed():
	text = "x" + str(GameState.idle_population)
	
	modulate = color_low if GameState.total_population < low_threshold else color_normal
