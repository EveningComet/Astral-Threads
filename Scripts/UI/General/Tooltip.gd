## Responsible for displaying information to the player.
class_name Tooltip extends PanelContainer

@export_category("General")
## The label that will display the name of the thing being focused/hovered.
## Could be things such as the character's name, an item name, and so on.
@export var title: Label

## Displays the description of something to the player.
@export var descriptor: Label

## Taking the passed UI element, determine what should be displayed.
func display(object: Control) -> void:
	if object is ItemSlotUI:
		var item_slot_data = (object as ItemSlotUI).slot
		_handle_item_data(item_slot_data)

func _handle_item_data(item_slot_data: ItemSlotData) -> void:
	var stored_item = item_slot_data.stored_item
	title.set_text(stored_item.localization_name)
	descriptor.set_text(stored_item.localization_description)
