## The state for when the player is moving on the ground.
class_name PLGround extends PLState

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{'velocity': var v}:
			velocity = v

func exit() -> void:
	velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	get_input_vector()
	apply_movement( delta )
	apply_friction( delta )
	cb.set_velocity( velocity )
	cb.move_and_slide()
	
	if cb.is_on_floor() == true and Input.is_action_just_pressed("jump"):
		my_state_machine.change_to_state("PLAir", {velocity = velocity, "max_jump_velocity" = max_jump_velocity})
		return
	
	if cb.is_on_floor() == false:
		my_state_machine.change_to_state("PLAir", {velocity = velocity})
		return
	
	orient_to_face_camera_direction(my_state_machine.camera_controller, delta)

func get_input_vector() -> void:
	# Get our movement value, adjusted to work with controllers
	input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_dir = input_dir.normalized() if input_dir.length() > 1 else input_dir
	
	# Adjust the input based on where we're looking
	input_dir = (input_dir.x * cb.transform.basis.x) + (input_dir.z * cb.transform.basis.z)

func apply_movement(delta: float) -> void:
	if input_dir != Vector3.ZERO:
		velocity.x = velocity.move_toward(input_dir * move_speed, ground_accel * delta).x
		velocity.z = velocity.move_toward(input_dir * move_speed, ground_accel * delta).z

func apply_friction(delta: float) -> void:
	if input_dir == Vector3.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO, ground_friction * delta)
