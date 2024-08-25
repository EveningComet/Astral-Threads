## Handles the cursor.
class_name CursorController extends Node

@export var cursor_prefab: PackedScene

var spawned_cursors: Array = []

## For single target actions
var curr_index: int = 0

func clear_cursors() -> void:
	for c in spawned_cursors:
		c.queue_free()
	spawned_cursors.clear()
