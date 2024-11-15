## Displays an instance of an item inside an inventory.
class_name ItemSlotUI extends Button

## Helps interfacing with the inventory.
signal item_slot_selected(index: int, button_index: int)

## The object that will display the item visuals to the player.
@export var display_icon: TextureRect

@export var amount_label: Label

## The attached slot data.
var _slot: ItemSlotData

## Represents where the item is located in an inventory. Used to help with sorting items.
var _index: int = -1

func _ready() -> void:
	gui_input.connect( on_gui_input )

## Set the item to display.
func set_slot_data(slot_data: ItemSlotData, new_index: int = -1) -> void:
	_slot  = slot_data
	_index = new_index
	
	update_quantity_text(_slot)
	if _slot != null:
		display_icon.set_texture( _slot.stored_item.image )
	
func update_quantity_text(slot_data: ItemSlotData) -> void:
	if _slot == null:
		amount_label.set_text( str(1) )
		amount_label.hide()
		return
	
	if slot_data.quantity > 1:
		amount_label.set_text( str(slot_data.quantity) )
		amount_label.show()
	else:
		amount_label.set_text( str(1) )
		amount_label.hide()

## Works with the engine's input system to see what button was used to select this.
func on_gui_input(event: InputEvent) -> void:
	# TODO: Figure out how to handle gamepad input.
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed():
			
			if OS.is_debug_build() == true:
				print("ItemSlotUI :: Pressed with mouse button: ", event.button_index)
			
			item_slot_selected.emit(
				_index if _index > -1 else get_index(),
				event.button_index
			)
