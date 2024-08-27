## State for where the player can select a target for some action.
class_name PBSelectTarget extends PlayerBattleState

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
			
			# TODO: Create the needed cursors

func exit() -> void:
	curr_action = null

func check_for_unhandled_input(event: InputEvent) -> void:
	# Back out to the select action state
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("PBSelectAction")
		return
	
	# TODO: Confirm the target.
	if event.is_action_pressed("ui_accept"):
		return
	
	# Checking for keyboard/gamepad input to move the cursor

func execute() -> void:
	# TODO: Store the targets for the action.
	store_action(curr_combatant, curr_action)
	
	# If the player has finished selecting actions for all their characters,
	# return to the idle state
	if my_state_machine.has_finished_selecting_needed_actions() == true:
		var actions_to_send: Array[StoredAction] = my_state_machine.get_actions()
		Eventbus.side_finished_turn.emit( actions_to_send )
		my_state_machine.end_of_turn_cleanup()
		my_state_machine.change_to_state("PBIdle")
		print("PBSelectTarget :: Player done with all party members.")
	
	# The player still has actions to select
	else	:
		my_state_machine.advance_to_next_character()
		my_state_machine.change_to_state("PBSelectAction")

func store_action(com_to_store: Combatant, action_to_store: StoredAction) -> void:
	my_state_machine.store_action(
		com_to_store,
		action_to_store
	)
