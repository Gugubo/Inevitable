class_name ActionButton
extends TextureButton

@onready var throbber_container =  $ThrobberContainer
@onready var required_resources_container = $RequiredResourcesContainer
@onready var animation_player = $AnimationPlayer

@onready var down_sfx = $ButtonDownSFX
@onready var up_sfx = $ButtonUpSFX
@onready var completed_sfx = $CompletedSFX

@export var throbber_scene: PackedScene
@export var resource_count_scene: PackedScene
@export var completed_sfx_stream: AudioStream

@export var action: Action

var item_to_icon: Dictionary[GameState.Item, ResourceCount.Icon] = {
	GameState.Item.WOOD: ResourceCount.Icon.WOOD,
	GameState.Item.STONE: ResourceCount.Icon.STONE,
	GameState.Item.FOOD: ResourceCount.Icon.FOOD,
	GameState.Item.TOOLS: ResourceCount.Icon.TOOLS,
}

func _ready() -> void:
	GameState.inventory_changed.connect(_on_inventory_changed)
	GameState.population_changed.connect(_on_population_changed)
	
	completed_sfx.stream = completed_sfx_stream
	
	update_state()
	
	_add_required_resources()


func _add_required_resources() -> void:
	for resource in action.required_items:
		_add_resource_count(item_to_icon[resource], action.required_items[resource])
	if action.required_population > 0:
		_add_resource_count(ResourceCount.Icon.POPULATION, action.required_population)


func _add_resource_count(icon: ResourceCount.Icon, count: int) -> void:
	var resource_count = resource_count_scene.instantiate() as ResourceCount
	resource_count.icon = icon
	resource_count.count = count
	required_resources_container.add_child(resource_count)


func _on_inventory_changed(item: GameState.Item) -> void:
	update_state()


func _on_population_changed() -> void:
	update_state()


func _on_pressed() -> void:
	# Make sure we have the required items
	if not GameState.has_items(action.required_items):
		return
	
	# Add runner
	var runner = ActionRunner.new()
	add_child(runner)
	runner.action_completed.connect(_on_completed)
	runner.start(action)
	
	# Add throbber
	var throbber = throbber_scene.instantiate()
	throbber.duration = action.duration
	throbber_container.add_child(throbber)
	
	update_state()


func _on_completed() -> void:
	completed_sfx.play()
	update_state() # Not really needed because inventory change already triggers an update


func update_state() -> void:
	disabled = (not GameState.has_items(action.required_items)) or (not GameState.has_idle_population(action.required_population))


func _on_mouse_entered() -> void:
	animation_player.play("show")


func _on_mouse_exited() -> void:
	animation_player.play_backwards("show")


func _on_button_down() -> void:
	down_sfx.play()


func _on_button_up() -> void:
	up_sfx.play()
