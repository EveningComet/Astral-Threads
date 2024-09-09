## Defines what the new game menu can do at a single point in time.
class_name NewGameMenuState extends State

## Some states will need to make sure the object holding the displayed
## party is hidden.
@export var active_party_container: Container

## Some states will need to display things to the player.
@export var description_displayer: DescriptionDisplayer

## The node that will house the portraits for a class.
var portraits_container: Container:
	get: return my_state_machine.portraits_container

var portrait_panel_template: PackedScene:
	get: return my_state_machine.portrait_panel_template

var portrait_button_template: PackedScene:
	get: return my_state_machine.portrait_button_template

func clear_portraits() -> void:
	for c in portraits_container.get_children():
		c.queue_free()
