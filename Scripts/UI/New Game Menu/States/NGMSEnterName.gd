## State for where the player is entering the name for a character.
class_name NGMSEnterName extends NewGameMenuState

@export var character_namer: CharacterNameInput

func enter(msgs: Dictionary = {}) -> void:
	character_namer.start_accepting_name(
		my_state_machine.curr_created_character
	)
	character_namer.name_entered.connect( on_finalized )

func exit() -> void:
	character_namer.name_entered.disconnect( on_finalized )

func on_finalized() -> void:
	# Add the newly created character to the party
	var new_pm: PlayerCombatant = my_state_machine.curr_created_character
	new_pm.stats.initialize() # TODO: Initialize based on starting class.
	PlayerPartyController.add_to_party(new_pm)
	
	# Setup the job and skills
	var primary_job: Job = my_state_machine.curr_job
	new_pm.initialize_with_job(primary_job)
	new_pm.skill_holder.skills.append_array(primary_job.skills)
	
	# Cleanup and return
	my_state_machine.curr_created_character = null
	my_state_machine.curr_job               = null
	my_state_machine.change_to_state("NGMSManageParty")
