class_name NGMSSelectJob extends NewGameMenuState

## The container that will hold the buttons for our class buttons.
@export var buttons_holder: Container

@export var character_job_button_prefab: PackedScene

func enter(msgs: Dictionary = {}) -> void:
	if my_state_machine.curr_created_character != null:
		my_state_machine.curr_created_character = null
		my_state_machine.curr_job               = null
	
	var pc: PlayerCombatant = PlayerCombatant.new()
	my_state_machine.curr_created_character = pc
	
	create_job_buttons()
	portraits_container.show()
	description_displayer.show()
	active_party_container.hide()

func exit() -> void:
	for c in buttons_holder.get_children():
		c.queue_free()
	
	clear_portraits()
	buttons_holder.hide()
	portraits_container.hide()
	description_displayer.hide()

func check_for_handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("NGMSManageParty")
		return
	
func create_job_buttons() -> void:
	for job: Job in Database.character_jobs:
		# Spawn the button and assign the data
		var jb: CharacterJobButton = character_job_button_prefab.instantiate()
		jb.job_data = job
		buttons_holder.add_child(jb)
		
		# Connect to relevant events
		jb.job_button_pressed.connect( on_job_button_pressed )
		jb.job_button_focused.connect( on_job_button_focused )
	
	buttons_holder.show()
	buttons_holder.get_child(0).grab_focus()

func on_job_button_pressed(job_data: Job) -> void:
	my_state_machine.curr_job = job_data
	my_state_machine.change_to_state("NGMSSelectPortrait")
	
func on_job_button_focused(job_data: Job) -> void:
	# Update the text
	description_displayer.update_text(job_data.localization_description)
	
	# Update the displayed portraits
	clear_portraits()
	var portraits: Array[PortraitData] = job_data.get_portraits()
	for pd: PortraitData in portraits:
		var portrait_displayer: PortraitDisplayerButton = portrait_button_template.instantiate()
		portrait_displayer.portrait_data = pd
		portrait_displayer.display_icon.set_texture(
			portrait_displayer.portrait_data.big_portrait
		)
		portraits_container.add_child(portrait_displayer)
	
