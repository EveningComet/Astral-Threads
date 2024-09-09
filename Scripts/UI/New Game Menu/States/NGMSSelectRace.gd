## State for where the player selects a portait for their character.
class_name NGMSSelectPortrait extends NewGameMenuState

func enter(msgs: Dictionary = {}) -> void:
	clear_portraits()
	
	for pd: PortraitData in my_state_machine.curr_job.get_portraits():
		var pdb: PortraitDisplayerButton = portrait_button_template.instantiate()
		pdb.portrait_data = pd
		pdb.display_icon.set_texture(pd.big_portrait)
		pdb.portrait_selected.connect( on_portrait_data_selected )
		portraits_container.add_child(pdb)
	
	# TODO: Another race condition here.
	await get_tree().create_timer(0.01).timeout
	portraits_container.show()
	portraits_container.get_child(0).grab_focus()

func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("NGMSSelectJob")
		return

func exit() -> void:
	clear_portraits()
	portraits_container.hide()

func on_portrait_data_selected(portrait_data: PortraitData) -> void:
	my_state_machine.curr_created_character.portrait_data = portrait_data
	my_state_machine.change_to_state("NGMSSelectStartingSkills")
