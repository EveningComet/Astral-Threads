## The middleman between an inventory and the visuals.
class_name PlayerDashboard extends CanvasLayer
# TODO: Since this will also display the equipment, this should

## The ui that will display the player's current inventory.
@export var player_inventory_displayer: InventoryDisplayer

@export var party_inspector: PartyInspector

## The ui that will display the contents of a shop, chest, and so on to the player.
@export var external_inventory_displayer: InventoryDisplayer

var player_inventory: Inventory

## This would be a chest, a shop, and so on.
var external_inventory: Inventory

# TODO: Hide when a battle has started.

func _ready() -> void:
	close()
	Eventbus.toggle_dashboard.connect( on_dashboard_toggled )
	player_inventory = PlayerInventory.inventory
	set_player_inventory(player_inventory)

func set_player_inventory(new_inventory: Inventory) -> void:
	player_inventory = new_inventory
	player_inventory.inventory_interacted.connect( on_inventory_interacted )
	player_inventory_displayer.set_inventory_to_display(player_inventory)

func set_external_inventory(new_inventory: Inventory) -> void:
	external_inventory = new_inventory
	external_inventory.inventory_interacted.connect( on_inventory_interacted )
	external_inventory_displayer.set_inventory_to_display(external_inventory)
	external_inventory_displayer.show()

func clear_external_inventory() -> void:
	if external_inventory != null:
		external_inventory.inventory_interacted.disconnect( on_inventory_interacted )
		external_inventory_displayer.clear_inventory()
		external_inventory = null
		external_inventory_displayer.hide()

## Used when the player interacts with an inventory data object.
func on_inventory_interacted(inventory_data: Inventory) -> void:
	pass

func open() -> void:
	player_inventory_displayer.show()
	party_inspector.show()
	show()

func close() -> void:
	player_inventory_displayer.hide()
	clear_external_inventory()
	party_inspector.hide()
	hide()

func on_dashboard_toggled(exterior_inv: Inventory = null) -> void:
	if visible == true:
		close()
	else:
		if exterior_inv != null:
			set_external_inventory(exterior_inv)
		open()
