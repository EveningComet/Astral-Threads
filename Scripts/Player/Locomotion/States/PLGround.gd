## The state for when the player is moving on the ground.
class_name PLGround extends PLState

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{'velocity': var v}:
			velocity = v

func exit() -> void:
	velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	apply_movement( delta )
	apply_friction( delta )
	cb.set_velocity( velocity )
	cb.move_and_slide()
	
	if cb.is_on_floor() == true and input_controller.jump_pressed == true:
		my_state_machine.change_to_state("PLAir", {velocity = velocity, "jumping" = true})
		return
	
	if cb.is_on_floor() == false:
		my_state_machine.change_to_state("PLAir", {velocity = velocity})
		return
	
	orient_to_face_camera_direction(my_state_machine.camera_controller, delta)
