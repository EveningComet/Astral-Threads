## Deals with displaying a particular character portrait to the player.
class_name PortraitDisplayerPanel extends PanelContainer

## Holds the specific portrait info to display.
@export var display_icon: TextureRect

## The current data to display.
var portrait_data: PortraitData:
	get:
		return portrait_data
	set(value):
		portrait_data = value
