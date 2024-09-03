## Stores an instance of an item.
class_name ItemSlotData extends Resource

## The item being stored.
@export var stored_item: ItemData = null

## The amount of the item.
@export var quantity: int = 0:
	set(value):
		# Legalize the quantity
		quantity = value
		if quantity > 1 and stored_item.max_stack_size == 1:
			quantity = 1

## When the slot needs to be refreshed.
func clear_data() -> void:
	stored_item = null
	quantity    = 0

## Remove and return one item of this.
func create_single_slot_data() -> ItemSlotData:
	var new_slot_data: ItemSlotData = ItemSlotData.new()
	new_slot_data.stored_item = stored_item
	new_slot_data.quantity    = 1
	quantity -= 1
	return new_slot_data

## Check if the item matches, we can stack, and the item has enough space for a partial merge.
func can_merge_with(other_slot_data: ItemSlotData) -> bool:
	return stored_item == other_slot_data.stored_item \
			and stored_item.max_stack_size > 1 \
			and quantity < stored_item.max_stack_size

## Check if the item matches, we can stack, and the item has enough space for a full merge.
func can_fully_merge_with(other_slot_data: ItemSlotData) -> bool:
	return stored_item == other_slot_data.stored_item \
			and stored_item.max_stack_size > 1 \
			and quantity + other_slot_data.quantity <= stored_item.max_stack_size

func fully_merge_with(other_slot_data: ItemSlotData) -> void:
	quantity += other_slot_data.quantity
