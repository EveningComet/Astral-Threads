## Responsible for managing what gets done when the player starts a new game.
class_name NewGameController extends StateMachine

func set_me_up() -> void:
	# TODO: Better way of loading audio.
	var audio: AudioStream = preload("res://Imported Assets/Audio/Music/Alkakrab Fantasy RPG Vol.3 Music Loops/Ambient 1 Loop.ogg")
	SoundManager.play_music(
		audio, 1.0, "Music"
	)
	super()
