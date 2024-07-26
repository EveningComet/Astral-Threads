## State for where the player is entering the name for a character.
class_name NGMSEnterName extends NewGameMenuState

func enter(msgs: Dictionary = {}) -> void:
	# Add the newly created character to the party
	var new_pm = my_state_machine.curr_created_character
	new_pm.reparent(PlayerPartyController)
	PlayerPartyController.add_to_party(new_pm)
	my_state_machine.curr_created_character = null
	my_state_machine.curr_job               = null
	
	my_state_machine.change_to_state("NGMSManageParty")
