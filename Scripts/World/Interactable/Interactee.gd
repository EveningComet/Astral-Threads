## A component for objects that need an [Interactable] object.
class_name Interactee extends Node

## Should this object only do its thing one time?
@export var one_shot: bool = false

## Child classes will define how they are interacted with.
func _on_interacted(interactable: Interactable) -> void:
	if one_shot == true:
		interactable.interacted.disconnect( _on_interacted )
