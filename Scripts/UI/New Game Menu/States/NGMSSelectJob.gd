class_name NGMSSelectJob extends NewGameMenuState

@export var character_job_button_prefab: PackedScene
@export var buttons_holder: Container

func enter(msgs: Dictionary = {}) -> void:
	description_displayer.show()
	create_job_buttons()
	active_party_container.hide()

func exit() -> void:
	for c in buttons_holder.get_children():
		c.queue_free()
	buttons_holder.hide()
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
	my_state_machine.change_to_state("NGMSSelectStartingSkills")
	
func on_job_button_focused(job_data: Job) -> void:
	description_displayer.update_text(job_data.localization_description)
