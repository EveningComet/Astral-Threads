## Responsible for managing the player's input.
class_name PlayerInputController extends Node

## Event that fires when the player the interaction button.
signal interact_pressed()

var input_dir: Vector3 = Vector3.ZERO

var jump_pressed:  bool = false
var jump_released: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Eventbus.toggle_mouse.connect( on_mouse_toggled )

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		# TODO: Interaction limit cooldown?
		interact_pressed.emit()
	elif event.is_action_pressed("inventory"):
		Eventbus.toggle_dashboard.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Disable input depending on the situation
	if Globals.is_movement_disabled == true:
		input_dir = Vector3.ZERO
		jump_pressed  = false
		jump_released = false
		return
		
	update_input_dir()
	
	jump_pressed  = false
	jump_released = false
	if Input.is_action_just_pressed("jump"):
		jump_pressed = true
	if Input.is_action_just_released("jump"):
		jump_released = true

func update_input_dir() -> void:
	input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_dir = input_dir.normalized() if input_dir.length() > 1 else input_dir

## Depending on what the eventbus says, enable/disable the use of the mouse.
func on_mouse_toggled(enable: bool) -> void:
	if enable == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
