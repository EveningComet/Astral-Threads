## State for where the player is selecting a race for their character.
class_name NGMSSelectRace extends NewGameMenuState

func enter(msgs: Dictionary = {}) -> void:
	if my_state_machine.curr_created_character != null:
		my_state_machine.curr_created_character = null
		my_state_machine.curr_job               = null
	
	var pc: PlayerCombatant = PlayerCombatant.new()
	my_state_machine.curr_created_character = pc
	description_displayer.show()
	active_party_container.hide()
	my_state_machine.change_to_state("NGMSSelectJob")

func exit() -> void:
	description_displayer.hide()
	active_party_container.show()
