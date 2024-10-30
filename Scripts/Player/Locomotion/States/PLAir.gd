## State that the player entered from either jumping or falling.
class_name PLAir extends PLState

# Jump & _gravity
@export var time_to_jump_apex: float = 0.4 # How long, in seconds, it takes us to reach the height of our jump
@export var max_jump_height:   float = 4   # How high we can jump
@export var min_jump_height:   float = 1   # How low we can jump
var _max_jump_velocity: float = 0
var _min_jump_velocity: float = 0
var _gravity:           float = 9.8

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	# Setup the _gravity
	_gravity = (2 * max_jump_height) / (time_to_jump_apex * time_to_jump_apex)
	_max_jump_velocity = sqrt(2 * _gravity * max_jump_height)
	_min_jump_velocity = sqrt(2 * _gravity * min_jump_height)

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		
		# Entered from a jump
		{'velocity': var v, 'jumping': var mjv}:
			velocity   = v
			velocity.y = _max_jump_velocity
		
		# Entered from falling
		{'velocity': var v}:
			velocity = v

func exit() -> void:
	velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	apply_movement( delta )
	apply_friction( delta )
	if input_controller.jump_released == true and velocity.y > _min_jump_velocity:
		velocity.y = _min_jump_velocity
	
	velocity.y -= _gravity * delta
	cb.set_velocity( velocity )
	cb.move_and_slide()
	
	if cb.is_on_ceiling() == true:
		velocity.y = 0
	
	if cb.is_on_floor() == true:
		velocity.y = 0
		my_state_machine.change_to_state("PLGround", {velocity = velocity})
		return
	
	orient_to_face_camera_direction(my_state_machine.camera_controller, delta)
