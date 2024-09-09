## A clickable version of the portrait displayer.
class_name PortraitDisplayerButton extends Button

signal portrait_selected(pd: PortraitData)

@export var display_icon: TextureRect

var portrait_data: PortraitData

func _ready() -> void:
	button_down.connect( on_button_down )

func on_button_down() -> void:
	portrait_selected.emit(portrait_data)
