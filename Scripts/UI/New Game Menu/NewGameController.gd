## Responsible for managing what gets done when the player starts a new game.
class_name NewGameController extends StateMachine

@export_category("Portrait Related")
@export var portrait_panel_template:  PackedScene
@export var portrait_button_template: PackedScene
@export var portraits_container: Container

## Keeps track of the currently crated character.
var curr_created_character: PlayerCombatant
var curr_job:               Job

func set_me_up() -> void:
	# TODO: Better way of loading audio.
	var audio: AudioStream = preload("res://Imported Assets/Audio/Music/Alkakrab Fantasy RPG Vol.3 Music Loops/Ambient 1 Loop.ogg")
	SoundManager.play_music(
		audio, 1.0, "Music"
	)
	super()

func _input(event: InputEvent) -> void:
	curr_state.check_for_handle_input(event)
