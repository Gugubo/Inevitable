class_name Action
extends Resource

@export var name: String = ""
@export var required_population: int = 0
@export var required_items: Dictionary[GameState.Item, int] = {}

@export var duration: float = 0 # in seconds

@export var loot: Array[Loot] = []
@export var morale: int = 0
@export var corruption: int = 0
@export var population_change: int = 0
