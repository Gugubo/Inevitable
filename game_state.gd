extends Node

enum Item { POPULATION, WOOD, STONE, FOOD, TOOLS, MORALE }

signal inventory_changed(item: Item)

var inventory: Dictionary[Item, int] = {
	Item.POPULATION: 0,
	Item.WOOD: 0,
	Item.STONE: 0,
	Item.FOOD: 0,
	Item.TOOLS: 0,
	Item.MORALE: 0,
}
var item_labels: Dictionary[Item, String] = {
	Item.POPULATION: "Population",
	Item.WOOD: "Wood",
	Item.STONE: "Stone",
	Item.FOOD: "Food",
	Item.TOOLS: "Tools",
	Item.MORALE: "Morale",
}


func add_item(item: Item, amount: int) -> void:
	inventory[item] += amount
	inventory_changed.emit(item)


func has_items(requirements: Dictionary[Item, int]) -> bool:
	for item in requirements:
		if inventory.get(item, 0) < requirements[item]:
			return false
	return true


func consume_items(items: Dictionary[Item, int]) -> void:
	for item in items:
		inventory[item] -= items[item]
		inventory_changed.emit(item)
