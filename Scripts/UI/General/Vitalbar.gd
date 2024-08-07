## A bar that simply displays a value of one a character's hp or sp to the player.
class_name Vitalbar extends ProgressBar
# TODO: Think of a better name.

@export var value_displayer: Label

func update_display(new_value: int, max_v: int = 100) -> void:
	max_value = max_v
	value     = new_value
	value_displayer.set_text( str(new_value) )
