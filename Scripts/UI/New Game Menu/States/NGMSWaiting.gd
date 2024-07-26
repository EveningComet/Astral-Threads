## The default state for the new game menu. This is for when the player is not
## doing anything in particular in regards to
## creating characters, starting the game, and so on.
class_name NGMSWaiting extends NewGameMenuState

@export var start_game_button:   Button
@export var manage_party_button: Button

## The container that holds the "main menu" set of buttons for this state.
@export var buttons_holder_container: Container

@export_file("*.tscn") var game_scene: String

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("NGMSWaiting :: Entered.")
	
	active_party_container.show()
	buttons_holder_container.show()
	buttons_holder_container.get_child(0).grab_focus()
	start_game_button.pressed.connect( on_start_game_pressed )
	manage_party_button.pressed.connect( on_manage_party_button_pressed )
	start_game_button.disabled = PlayerPartyController.has_party_members() == false

func exit() -> void:
	buttons_holder_container.hide()
	start_game_button.pressed.disconnect( on_start_game_pressed )
	manage_party_button.pressed.disconnect( on_manage_party_button_pressed )
	buttons_holder_container.hide()

func on_start_game_pressed() -> void:
	SceneManager.change_scene(game_scene)
	SoundManager.stop_music(1.0)

## When the player presses the relevant button, switch to the state that
## will allow the player to add and remove party members.
func on_manage_party_button_pressed() -> void:
	my_state_machine.change_to_state("NGMSManageParty")
