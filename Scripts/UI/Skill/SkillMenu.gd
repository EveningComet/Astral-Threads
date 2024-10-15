## Manages all the stuff related to visually displaying skills to the player.
## In addition, this is responsible for unlocking and relocking the usable skills.
class_name SkillMenu extends CanvasLayer

## The character that is currently having their skills displayed.
var _curr_char: Combatant

## The currently available skill points.
var curr_skill_points: int = 0

func _ready() -> void:
	Eventbus.toggle_skill_menu.connect( _on_skill_menu_toggled )
	close()

## Stop showing the menu.
func close() -> void:
	hide()

func _on_skill_menu_toggled(turn_on: bool) -> void:
	pass
