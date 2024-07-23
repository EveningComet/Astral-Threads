## State that the player entered from either jumping or falling.
class_name PLAir extends PLState

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	# Setup the gravity
	gravity = (2 * max_jump_height) / (time_to_jump_apex * time_to_jump_apex)
	max_jump_velocity = sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = sqrt(2 * gravity * min_jump_height)

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		
		# Entered from a jump
		{'velocity': var v, 'max_jump_velocity': var mjv}:
			velocity   = v
			velocity.y = max_jump_velocity
		
		# Entered from falling
		{'velocity': var v}:
			velocity = v

func exit() -> void:
	velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	get_input_vector()
	apply_movement( delta )
	apply_friction( delta )
	if Input.is_action_just_released("jump") and velocity.y > min_jump_velocity:
		velocity.y = min_jump_velocity
	
	velocity.y -= gravity * delta
	cb.set_velocity( velocity )
	cb.move_and_slide()
	
	if cb.is_on_ceiling() == true:
		velocity.y = 0
	
	if cb.is_on_floor() == true:
		velocity.y = 0
		my_state_machine.change_to_state("PLGround", {velocity = velocity})
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
		velocity.x = velocity.move_toward(input_dir * move_speed, air_accel * delta).x
		velocity.z = velocity.move_toward(input_dir * move_speed, air_accel * delta).z

func apply_friction(delta: float) -> void:
	if input_dir == Vector3.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO, air_friction * delta)
