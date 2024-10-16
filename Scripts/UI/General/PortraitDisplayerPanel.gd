## Deals with displaying a particular character portrait to the player.
class_name PortraitDisplayerPanel extends PanelContainer

## Holds the specific portrait info to display.
@export var display_icon: TextureRect

## Stylebox to show an active portrait
@export var highlighted_style : StyleBoxFlat

## The current data to display.
var portrait_data: PortraitData:
	get:
		return portrait_data
	set(value):
		portrait_data = value

func highlight() -> void:
	add_theme_stylebox_override("panel", highlighted_style)

func unhighlight() -> void:
	remove_theme_stylebox_override("panel")
	
