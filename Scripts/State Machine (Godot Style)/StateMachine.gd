## Base class for a state machine.
class_name StateMachine extends Node

@export var initial_state := NodePath()

# The states we're managing and the state we're currently in
var states:     Dictionary = {}
var curr_state: State      = null

func _ready() -> void:
	set_me_up()

func set_me_up() -> void:
	# Initialize the states on the data side
	for child in get_children():
		states[child.name] = child
		states[child.name].setup_state( self )
	curr_state = get_node(initial_state)
	curr_state.enter()

## Change to the passed state, with parameters if needed
func change_to_state(state_to_enter: String, msgs: Dictionary = {}) -> void:
	if has_node(state_to_enter) == false:
		return
	
	if curr_state != null:
		curr_state.exit()
	
	curr_state = get_node(state_to_enter)
	curr_state.enter( msgs )
