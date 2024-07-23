## State for when the player is not doing anything in particular in regards to
## creating characters, starting the game, and so on.
class_name NGMSWaiting extends NewGameMenuState

@export var buttons_holder_container: Container
@export var start_game_button: Button

@export_file("*.tscn") var game_scene: String

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("NGMSWaiting :: Entered.")
	
	buttons_holder_container.show()
	buttons_holder_container.get_child(0).grab_focus()
	start_game_button.pressed.connect( on_start_game_pressed )

func exit() -> void:
	buttons_holder_container.hide()
	start_game_button.pressed.disconnect( on_start_game_pressed )

func on_start_game_pressed() -> void:
	SceneManager.change_scene(game_scene)
	SoundManager.stop_music(1.0)
