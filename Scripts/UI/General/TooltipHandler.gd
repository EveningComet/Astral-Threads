## Responsible for displaying tooltips for a player.
class_name TooltipHandler extends CanvasLayer

## Prefab of the tooltip scene.
@export var tooltip_scene: PackedScene
# TODO: Pass along any components that will be needed.

@onready var _tooltip_holder: Control = $Control

func _ready() -> void:
	Eventbus.tooltip_needed.connect( _on_tooltip_needed )
	Eventbus.tooltip_unneeded.connect( _on_free_tooltip )

## Spawns a tooltip.
func _on_tooltip_needed(object: Control) -> void:
	var tooltip: Tooltip = tooltip_scene.instantiate()
	_tooltip_holder.add_child(tooltip)
	# TODO: Figure out placement.
	tooltip.global_position = object.global_position + object.size + Vector2.UP
	tooltip.display(object)

func _on_free_tooltip() -> void:
	for tooltip in _tooltip_holder.get_children():
		tooltip.queue_free()
