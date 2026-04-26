class_name Action
extends Resource

enum WorkArea { PLACE, FOREST, MINE }

@export var name: String = ""
@export var work_area: WorkArea = WorkArea.PLACE
@export var required_population: int = 0
@export var duration: float = 0 # in seconds

@export var required_items: Dictionary[GameState.Item, int] = {}

@export var loot: Array[Loot] = []
@export var morale: float = 0.0
@export var corruption: float = 0.0
@export var population_change: int = 0
