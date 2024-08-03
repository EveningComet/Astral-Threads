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
	
	new_character_button.pressed.connect( on_new_character_button_pressed )
	check_if_new_characters_can_be_added()

func exit() -> void:
	manage_party_buttons_container.hide()
	new_character_button.pressed.disconnect( on_new_character_button_pressed )

func check_for_handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("NGMSWaiting")
		return

## Checks if there are any open slots in the party. If not, prevent anyone else
## from being added.
func check_if_new_characters_can_be_added() -> void:
	for pm: PlayerCombatant in PlayerPartyController.get_party():
		if pm == null:
			return
	new_character_button.disabled = true

func on_new_character_button_pressed() -> void:
	my_state_machine.change_to_state("NGMSSelectRace")
