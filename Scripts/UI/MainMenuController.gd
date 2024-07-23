## Manages the main menu.
class_name MainMenuController extends Node

@export var start_game_button: Button
@export var quit_button: Button
@export var button_holder: Container

@export_file("*.tscn") var game_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game_button.pressed.connect(on_start_game_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	# Allow gamepad controls
	button_holder.get_child(0).grab_focus()

func on_start_game_pressed() -> void:
	SceneManager.change_scene(game_scene_path)

func on_quit_button_pressed() -> void:
	get_tree().quit()
