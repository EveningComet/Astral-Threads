## The middleman between an inventory and the visuals.
class_name PlayerDashboard extends CanvasLayer

## The ui that will display the player's current inventory.
@export var player_inventory_displayer: InventoryDisplayer

@export var party_inspector: PartyInspector

## The ui that will display the contents of a shop, chest, and so on to the player.
@export var external_inventory_displayer: InventoryDisplayer

@export_category("Drag & Drop")
## Used for displaying a dragged item to the player.
@export var grabbed_slot_ui: ItemSlotUI

## Stores an item that the player might do something with. E.g: equip to someone.
var _grabbed_slot_data: ItemSlotData = null

## Reference to the data of the player's inventory.
var player_inventory: Inventory

## This would be a chest, a shop, and so on.
var external_inventory: Inventory

## The current character the player is inspecting in the party inspector.
var _curr_inspected_pm: PlayerCombatant

func _ready() -> void:
	close()
	Eventbus.toggle_dashboard.connect( on_dashboard_toggled )
	Eventbus.start_battle.connect( on_battle_started )
	visibility_changed.connect( _on_visibility_changed )
	
	player_inventory = PlayerInventory.inventory
	set_player_inventory(player_inventory)
	
	party_inspector.displayed_character_changed.connect(
		on_inspected_party_member_changed
	)
	
func _input(event: InputEvent) -> void:
	if grabbed_slot_ui.visible == true:
		# Display the grabbed slot at the mouse position with an offset
		grabbed_slot_ui.global_position = party_inspector.get_global_mouse_position() + Vector2(5, 5)

## Setup the player's inventory.
func set_player_inventory(new_inventory: Inventory) -> void:
	player_inventory = new_inventory
	player_inventory.inventory_interacted.connect( on_inventory_interacted )
	player_inventory_displayer.set_inventory_to_display(player_inventory)
	
	# Connect to the gui input of the player's inventory ui so dragging and dropping
	# is easy
	player_inventory_displayer.gui_input.connect( on_player_inventory_gui_input )

## Set the external inventory that the player will be able to interact with.
func set_external_inventory(new_inventory: Inventory) -> void:
	external_inventory = new_inventory
	external_inventory.inventory_interacted.connect( on_inventory_interacted )
	external_inventory_displayer.set_inventory_to_display(external_inventory)
	external_inventory_displayer.show()
	
	# Connect to the gui input of the external inventory so that we can easily
	# drop items into it
	external_inventory_displayer.gui_input.connect( _on_external_inventory_gui_input )

func clear_external_inventory() -> void:
	if external_inventory != null:
		external_inventory.inventory_interacted.disconnect( on_inventory_interacted )
		external_inventory_displayer.clear_inventory()
		external_inventory_displayer.gui_input.disconnect( _on_external_inventory_gui_input )
		external_inventory = null
		external_inventory_displayer.hide()

func open() -> void:
	player_inventory_displayer.show()
	party_inspector.open()
	show()
	Eventbus.toggle_mouse.emit(true)

func close() -> void:
	player_inventory_displayer.hide()
	clear_external_inventory()
	party_inspector.close()
	Eventbus.toggle_mouse.emit(false)
	hide()

func _on_visibility_changed() -> void:
	# Prevent the potential loss of items
	if visible == false and _grabbed_slot_data != null:
		player_inventory.add_slot_data( _grabbed_slot_data )
		_grabbed_slot_data = null
		update_grabbed_slot()

## Turn off the dashboard, but still keep the mouse up.
func on_battle_started() -> void:
	close()
	Eventbus.toggle_mouse.emit(true)

## Used when the player interacts with an inventory data object.
func on_inventory_interacted(inventory_data: Inventory, index: int, button_index: int) -> void:	
	match [_grabbed_slot_data, button_index]:
		
		# The player wants to grab the whole item
		[null, MOUSE_BUTTON_LEFT]:
			_grabbed_slot_data = inventory_data.grab_slot_data(index)
		
		# The player wants to drop the item in a new slot
		[_, MOUSE_BUTTON_LEFT]:
			_grabbed_slot_data = inventory_data.drop_slot_data(_grabbed_slot_data, index)
		
		# Attempt to use the item
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data( index )
		
		# Player is trying to drop a piece of the slot
		[_, MOUSE_BUTTON_RIGHT]:
			_grabbed_slot_data = inventory_data.drop_single_slot_data(_grabbed_slot_data, index)
		
	update_grabbed_slot()
			
## Called whenever the inspected character is changed in the party inspector.
func on_inspected_party_member_changed(new_ipm: PlayerCombatant) -> void:
	if _curr_inspected_pm != null:
		_curr_inspected_pm.equipment_holder.inventory_interacted.disconnect(on_inventory_interacted )
	
	_curr_inspected_pm = new_ipm
	_curr_inspected_pm.equipment_holder.inventory_interacted.connect( on_inventory_interacted )

func on_player_inventory_gui_input(event: InputEvent) -> void:
	if _grabbed_slot_data != null:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			player_inventory.add_slot_data( _grabbed_slot_data )
			_grabbed_slot_data = null
			update_grabbed_slot()

func _on_external_inventory_gui_input(event: InputEvent) -> void:
	if _grabbed_slot_data != null:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			external_inventory.add_slot_data( _grabbed_slot_data )
			_grabbed_slot_data = null
			update_grabbed_slot()
			
func on_dashboard_toggled(exterior_inv: Inventory = null) -> void:
	if visible == true:
		close()
	else:
		if exterior_inv != null:
			set_external_inventory(exterior_inv)
		open()

func update_grabbed_slot() -> void:
	if _grabbed_slot_data != null:
		grabbed_slot_ui.global_position = party_inspector.get_global_mouse_position()
		grabbed_slot_ui.show()
		grabbed_slot_ui.set_slot_data( _grabbed_slot_data )
	else:
		grabbed_slot_ui.hide()
