## Displays an instance of an item inside an inventory.
class_name ItemSlotUI extends Button

## Helps interfacing with the inventory.
signal item_slot_selected(item_slot_data: ItemSlotData)

## The object that will display the item visuals to the player.
@export var display_icon: TextureRect

@export var amount_label: Label

## The attached slot data.
var slot: ItemSlotData

func _ready() -> void:
	pressed.connect( on_pressed )

func set_slot_data(slot_data: ItemSlotData) -> void:
	slot = slot_data
	update_quantity_text(slot)
	if slot != null:
		display_icon.set_texture( slot.stored_item.image )
	
func update_quantity_text(slot_data: ItemSlotData) -> void:
	if slot == null:
		amount_label.set_text( str(1) )
		amount_label.hide()
		return
	
	if slot_data.quantity > 1:
		amount_label.set_text( str(slot_data.quantity) )
		amount_label.show()
	else:
		amount_label.set_text( str(1) )
		amount_label.hide()

func on_pressed() -> void:
	item_slot_selected.emit(slot)
