## Responsible for displaying the current party and their stats to the player.
class_name PartyInspector extends Control

## Fired whenever the player changes the character they're looking at.
signal displayed_character_changed(new_char: PlayerCombatant)

## Whenever a stat has changed, update to reflect the values.
func _on_stat_changed(combatant: PlayerCombatant) -> void:
	pass
