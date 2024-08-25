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
	apply_movement( delta )
	apply_friction( delta )
	if input_controller.jump_released == true and velocity.y > min_jump_velocity:
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

func apply_movement(delta: float) -> void:
	if input_dir != Vector3.ZERO:
		velocity.x = velocity.move_toward(input_dir * move_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(input_dir * move_speed, acceleration * delta).z

func apply_friction(delta: float) -> void:
	if input_dir == Vector3.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
