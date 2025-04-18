## Handles displaying an inventory.
class_name InventoryDisplayer extends Control

## The inventory being displayed.
@export var inventory_to_display: Inventory

## Template of the item slot.
@export var item_slot_prefab: PackedScene

## The container that will house the items.
@export var item_container: Control

@export_category("Money")
@export var displays_money:    bool  = false
@export var money_value_label: Label = null

func set_inventory_to_display(new_inventory: Inventory) -> void:
	inventory_to_display = new_inventory
	inventory_to_display.inventory_updated.connect( populate_item_container )
	populate_item_container( inventory_to_display )

## Clear the displayed inventory.
func clear_inventory() -> void:
	inventory_to_display.inventory_updated.disconnect( populate_item_container )
	inventory_to_display = null
	clear_contents()

## Populate the items that should be displayed.
## If this is called due to a signal, this simply updates the display.
func populate_item_container(inventory_data: Inventory) -> void:
	clear_contents()
	
	# Create the slots
	for slot_data in inventory_data.stored_items:
		var slot: ItemSlotUI = item_slot_prefab.instantiate()
		item_container.add_child(slot)
		
		# Connect to relevant events
		slot.item_slot_selected.connect( inventory_to_display.on_slot_selected )
		
		# If the current slot has something to show
		if slot_data != null:
			slot.set_slot_data(slot_data)

## Clears all the displayed items.
func clear_contents() -> void:
	for c in item_container.get_children():
		c.queue_free()
