## State for where the player is selecting a race for their character.
class_name NGMSSelectRace extends NewGameMenuState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.change_to_state("NGMSSelectJob")
