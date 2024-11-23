## A component for character bodies to interact with physics objects.
class_name Pusher extends Node

@export var push_force: float = 10.0
var _cb: CharacterBody3D

func _ready() -> void:
	if get_parent() is not CharacterBody3D:
		queue_free()
		return
	
	_cb = get_parent()
	
func _physics_process(delta: float) -> void:
	for i in _cb.get_slide_collision_count():
		var coll = _cb.get_slide_collision(i)
		
		# When colliding with a rigidbody, apply the push force, scaled
		# by the character's speed
		if coll.get_collider() is RigidBody3D:
			var direction:   Vector3 = -coll.get_normal()
			var speed:       float   = _cb.velocity.length()
			var impulse_pos: Vector3 = coll.get_position() - coll.get_collider().global_position
			
			# Finally, apply the force
			coll.get_collider().apply_impulse(
				direction * speed * push_force,
				impulse_pos
			)
