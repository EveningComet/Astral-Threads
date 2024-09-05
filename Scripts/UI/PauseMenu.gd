## Handles the pause menu.
class_name PauseMenu extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: Better place to enable the player hud
	PlayerHUD.open()
	
	# Start the menu off hidden
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_state   = not get_tree().paused
		get_tree().paused = pause_state
		visible           = pause_state
