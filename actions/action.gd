class_name Action
extends Resource

@export var name: String = ""
@export var required_items: Dictionary[GameState.Item, int] = {}

@export var duration: float = 0 # in seconds

@export var loot: Array[Loot] = []
