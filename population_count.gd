extends Label


func _ready():
	GameState.population_changed.connect(_on_population_changed)
	_on_population_changed()


func _on_population_changed():
	text = "x" + str(GameState.population)
