## A component for objects that need an [Interactable] object.
class_name Interactee extends Node

## The [Interactable] that this object cares about.
@export var interactable: Interactable = null

## Should this object only do its thing one time?
@export var one_shot: bool = false

func _ready() -> void:
	if interactable != null:
		interactable.interacted.connect( _on_interacted )

func _on_interacted() -> void:
	if one_shot == true:
		interactable.interacted.disconnect( _on_interacted )
