## Houses items.
class_name Inventory extends Resource

## Whenever this inventory gets updated, pass it along.
signal inventory_updated(inventory: Inventory)

## When interacted with, we want others to know about the interaction.
signal inventory_interacted(inventory_data: Inventory, slot_data: ItemSlotData)

signal money_changed(amt: int)

## The items being kept track of.
@export var stored_items: Array[ItemSlotData] = []

## How much money this inventory is storing.
var money: int = 0

func initialize_slots() -> void:
	stored_items.clear()

func add_money(amt: int) -> void:
	money += amt
	money_changed.emit( money )

## Return a slot data object, given the passed index.
func grab_slot_data(index: int) -> ItemSlotData:
	var slot_data: ItemSlotData = stored_items[index]
	
	# If we have a slot to move, remove the slot and tell anyone caring about the change.
	if slot_data != null and slot_data.stored_item != null:
		stored_items.remove_at(index)
		inventory_updated.emit( self )
		return slot_data
	else:
		return null

func grab_and_remove_slot_data(slot_data: ItemSlotData) -> ItemSlotData:
	var index: int = stored_items.find(slot_data)
	var slot_to_remove = stored_items[index]
	stored_items.erase(slot_data)
	inventory_updated.emit(self)
	return slot_to_remove

## Attempt to drop a single slot.
func drop_single_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	var slot_data: ItemSlotData = stored_items[index]
	
	if slot_data == null or slot_data.stored_item == null:
		stored_items[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data) == true:
		slot_data.fully_merge_with( grabbed_slot_data.create_single_slot_data() )
	
	inventory_updated.emit( self )
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null 

## Attempt to drop a slot data at the index, and swap the item if we can
func drop_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	var slot_data: ItemSlotData = stored_items[index]
	
	var return_slot_data: ItemSlotData
	if slot_data != null and slot_data.stored_item != null and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		stored_items[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit( self )
	return return_slot_data

## Use the stored item at the passed index.
func use_slot_data(index: int) -> void:
	# TODO: Make this return the item so that the characters will be able to use them or fire an event.
	var slot_data: ItemSlotData = stored_items[index]
	
	# There is no item at the passed index, so do nothing.
	if slot_data == null or slot_data.stored_item == null:
		return
	
	# Depending on the item, this is where we do stuff.
	# If the item is a consumable, it needs to do its thing and then decrement.
	if slot_data.stored_item.item_type == ItemTypes.ItemTypes.Consumable:
		slot_data.quantity -= 1
		
		# TODO: This is where the usage of the item will go.
		
		if slot_data.quantity < 1:
			stored_items[index] = null
	
	# Tell anything that needs to know about the change
	inventory_updated.emit( self )
	
	if OS.is_debug_build() == true:
		print("Inventory :: Attempting to use item: %s." % [slot_data.stored_item.localization_name])

## Used when adding a single slot data.
func add_slot_data(slot_data: ItemSlotData) -> void:
	
	# If we find a slot we can stack to, try it
	for index in stored_items.size():
		if stored_items[index] != null and stored_items[index].can_fully_merge_with(slot_data) == true:
			stored_items[index].fully_merge_with(slot_data)
			inventory_updated.emit( self )
			return
	
	# A previous, stackable item was not found, add the new one
	stored_items.append( slot_data )
	inventory_updated.emit( self )

## Gets called through interacting with an item slot in the UI.
func on_slot_selected(slot_data: ItemSlotData) -> void:
	inventory_interacted.emit(self, slot_data)

func has_item(item: ItemData) -> bool:
	for slot: ItemSlotData in stored_items:
		if slot != null and slot.stored_item != null and slot.stored_item == item:
			return true
	return false
