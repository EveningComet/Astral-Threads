class_name NGMSSelectStartingSkills extends NewGameMenuState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.change_to_state("NGMSEnterName")
