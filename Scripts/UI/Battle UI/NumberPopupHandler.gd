## Handles displaying things such as damage number popups to the player.
extends CanvasLayer

## Prefab of the node that will display the text values.
@export var number_displayer: PackedScene

func display_number(value: int, pos: Vector2, status: String) -> void:
	var battle_number: BattleNumberPopup = number_displayer.instantiate()
	battle_number.global_position = pos
	add_child(battle_number)
	
	if status.contains("healing"):
		battle_number.set("theme_override_colors/font_color", Color.GREEN)
	
	battle_number.display(value)
