## Defines a state on how the player should move.
class_name PLState extends State

## Every state needs to check for movement in some way.
var cb: CharacterBody3D

# Air, Speed, & Friction
@export var move_speed:      float = 10   # How fast this state moves
@export var acceleration:    float = 60.0
@export var friction:        float = 50.0
@export var rot_speed:       float = 10.0 # How fast we rotate

# Jump & gravity
@export var time_to_jump_apex: float = 0.4 # How long, in seconds, it takes us to reach the height of our jump
@export var max_jump_height:   float = 4   # How high we can jump
@export var min_jump_height:   float = 1   # How low we can jump
var max_jump_velocity: float = 0
var min_jump_velocity: float = 0
var gravity:           float = 9.8

# Every state needs to keep track of their movement vector and input
var velocity:  Vector3 = Vector3.ZERO
var input_dir: Vector3 = Vector3.ZERO

## Handle our animations.
var animation_tree: AnimationTree

var input_controller: PlayerInputController

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	cb               = new_sm.cb
	input_controller = new_sm.input_controller

func handle_animations(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	get_input_vector()
	handle_move( delta )

func get_input_vector() -> void:
	# Get our movement value, adjusted to work with controllers
	input_dir = Vector3.ZERO
	input_dir.x = input_controller.input_dir.x
	input_dir.z = input_controller.input_dir.z
	
	# Adjust the input based on where we're looking
	input_dir = (input_dir.x * cb.transform.basis.x) + (input_dir.z * cb.transform.basis.z)

func handle_move(delta: float) -> void:
	pass

func handle_gravity(delta: float) -> void:
	pass

func apply_movement(delta: float) -> void:
	pass

func apply_friction(delta: float) -> void:
	pass
	
## Many of the movement states need to update the character's facing direction
## based on the camera.
func orient_to_face_camera_direction(camera: CameraController, delta: float) -> void:
	var direction = (camera.global_transform.basis * Vector3.BACK).normalized()
	var q_from = cb.transform.basis.get_rotation_quaternion()
	var left_axis = Vector3.UP.cross(direction)
	var rotation_basis = Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
	cb.basis = Basis(q_from.slerp(rotation_basis, delta * rot_speed))
	
	# Prevent weird stuff from happening
	cb.transform.basis = cb.transform.basis.orthonormalized()

func check_if_on_ground_or_ceiling() -> void:
	# Don't calculate gravity if we're on the ground and make us fall down when hitting the ceiling
	if cb.is_on_floor() == true or cb.is_on_ceiling() == true:
		velocity.y = 0
