## State for where the player can select a target for some action.
class_name PBSelectTarget extends PlayerBattleState

@export var cursor_controller: CursorController

var curr_action: StoredAction = null

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{"stored_action": var sa}:
			curr_action = sa
			
			# Depending on the action type, just move on
			match curr_action.action_type:
				ActionTypes.ActionTypes.Self, ActionTypes.ActionTypes.Defend, \
				ActionTypes.ActionTypes.Flee:
					execute()
					return
			
			# Create the needed cursors
			cursor_controller.spawn_needed_cursors(curr_action)
			# TODO: Mouse control for convenience.

func exit() -> void:
	curr_action = null
	cursor_controller.clear_cursors()

func check_for_unhandled_input(event: InputEvent) -> void:
	# Back out to the select action state
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("PBSelectAction")
		return
	
	# Confirming the target
	if event.is_action_pressed("ui_accept"):
		execute()
		return
	
	# Checking for keyboard/gamepad input to move the cursor
		# Check for keyboard/gamepad input to move the cursor
	var input_dir: Vector2 = Vector2.ZERO
	if event.is_action_pressed("ui_up"):
		input_dir = Vector2.UP
	if event.is_action_pressed("ui_right"):
		input_dir = Vector2.RIGHT
	if event.is_action_pressed("ui_down"):
		input_dir = Vector2.DOWN
	if event.is_action_pressed("ui_left"):
		input_dir = Vector2.LEFT
	
	if input_dir != Vector2.ZERO:
		cursor_controller.find_closest_target( input_dir )

func execute() -> void:
	# Store the targets for the action and then cache that action
	curr_action.set_targets( cursor_controller.get_targets() )
	store_action(curr_combatant, curr_action)
	
	# If the player has finished selecting actions for all their characters,
	# return to the idle state
	if my_state_machine.has_finished_selecting_needed_actions() == true:
		var actions_to_send: Array[StoredAction] = my_state_machine.get_actions()
		Eventbus.side_finished_turn.emit( actions_to_send )
		my_state_machine.end_of_turn_cleanup()
		my_state_machine.change_to_state("PBIdle")
	
	# The player still has actions to select
	else	:
		my_state_machine.advance_to_next_character()
		my_state_machine.change_to_state("PBSelectAction")

func store_action(com_to_store: Combatant, action_to_store: StoredAction) -> void:
	my_state_machine.store_action(
		com_to_store,
		action_to_store
	)
