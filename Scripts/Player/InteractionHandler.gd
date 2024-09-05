## Manages interactions for the player.
class_name InteractionHandler extends Node

@export var interaction_cast: RayCast3D
@export var input_controller: PlayerInputController

## How far away the player is allowed to be from this object before the inventory gets closed.
@export var max_distance_before_closing_inventory: float = 5.5

var curr_world_inventory: WorldInventory = null

func _ready() -> void:
	set_physics_process(false)
	input_controller.interact_pressed.connect( on_interaction_pressed )

func _physics_process(delta: float) -> void:
	var distance = get_parent().global_position.distance_squared_to(curr_world_inventory.get_parent().global_position)
	if distance > max_distance_before_closing_inventory * max_distance_before_closing_inventory:
		# TODO: Oversight bug here. Closing inventory and walking away will cause it to reopen.
		Eventbus.toggle_dashboard.emit()
		curr_world_inventory = null
		set_physics_process(false)

func on_interaction_pressed() -> void:
	set_physics_process(false)
	curr_world_inventory = null
	if interaction_cast.is_colliding() == true:
		var collider = interaction_cast.get_collider()
		if collider.has_node("WorldInventory"):
			var world_inventory: WorldInventory = collider.get_node("WorldInventory")
			curr_world_inventory = world_inventory
	
	if curr_world_inventory != null:
		Eventbus.toggle_dashboard.emit(curr_world_inventory.inventory)
		if OS.is_debug_build() == true:
			print("InteractionHandler :: In range of interactable inventory.")
		set_physics_process(true)
