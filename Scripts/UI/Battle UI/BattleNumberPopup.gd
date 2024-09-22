## Displays a value during battle.
class_name BattleNumberPopup extends Label

@export var y_change: float = 30.0
@export var duration: float = 1.0

func display(value: int) -> void:
	show()
	set_text(str(value))
	
	# Use a tween to animate the text
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		self, "global_position:y", global_position.y - y_change, duration
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self, "modulate:a", 0, duration
	).set_ease(Tween.EASE_IN)
	
	await tween.finished
	queue_free()
