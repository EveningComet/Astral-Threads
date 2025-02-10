## State for where the game is waiting for the player to decide if they want
## to add or remove party members.
class_name NGMSManageParty extends NewGameMenuState

@export var new_character_button:    Button
@export var remove_character_button: Button

@export var manage_party_buttons_container: Container

func enter(msgs: Dictionary = {}) -> void:
	active_party_container.show()
	manage_party_buttons_container.show()
	manage_party_buttons_container.get_child(0).grab_focus()
	
	new_character_button.pressed.connect( _on_new_character_button_pressed )
	remove_character_button.pressed.connect( _on_remove_character_button_pressed )
	_check_if_new_characters_can_be_added()

func exit() -> void:
	manage_party_buttons_container.hide()
	new_character_button.pressed.disconnect( _on_new_character_button_pressed )
	remove_character_button.pressed.disconnect( _on_remove_character_button_pressed )

func check_for_handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("NGMSWaiting")
		return

## Checks if there are any open slots in the party. If not, prevent anyone else
## from being added.
func _check_if_new_characters_can_be_added() -> void:
	for pm: PlayerCombatant in PlayerPartyController.get_party():
		if pm == null:
			new_character_button.disabled = false
			return
	new_character_button.disabled = true

func _on_new_character_button_pressed() -> void:
	my_state_machine.change_to_state("NGMSSelectJob")

func _on_remove_character_button_pressed() -> void:
	# TODO: Create a state explicitly for managing the removal of party members.
	# For now, only the last party member added will be removed.
	PlayerPartyController.remove_last_member()
	_check_if_new_characters_can_be_added()
