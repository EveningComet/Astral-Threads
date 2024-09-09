## Responsible for displaying the current party and their stats to the player.
class_name PartyInspector extends Control

## Fired whenever the player changes the character they're looking at.
signal displayed_character_changed(new_char: PlayerCombatant)

@export var attributes_container: Container

## The current party member the character is looking at.
var curr_inspected_pm: PlayerCombatant

func open() -> void:
	set_pm_to_inspect(PlayerPartyController.get_party()[0])
	show()

func close() -> void:
	hide()

## Set the current party member to look at.
func set_pm_to_inspect(new_pm: PlayerCombatant) -> void:
	if curr_inspected_pm != null:
		curr_inspected_pm.stat_changed.disconnect( _on_stat_changed )
	
	curr_inspected_pm = new_pm
	curr_inspected_pm.stat_changed.connect( _on_stat_changed )

## Whenever a stat has changed, update to reflect the values.
func _on_stat_changed(combatant: PlayerCombatant) -> void:
	pass
