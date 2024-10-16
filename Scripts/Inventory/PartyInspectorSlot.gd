class_name PartyInspectorSlot extends Control

## Visually represents what character is currently being looked at.
@export var portrait_displayer: PortraitDisplayerPanel

@export var level_value_label: Label

## The current party member the character is looking at.
var curr_inspected_pm: PlayerCombatant

## Set the current party member to look at.
func set_active_portrait(new_pm: PlayerCombatant) -> void:
	if curr_inspected_pm != null:
		curr_inspected_pm.stat_changed.disconnect( _on_stat_changed )
	
	curr_inspected_pm = new_pm
	level_value_label.set_text( str(curr_inspected_pm.curr_level) )
	portrait_displayer.portrait_data = new_pm.portrait_data
	portrait_displayer.display_icon.set_texture(new_pm.portrait_data.small_portrait)
	curr_inspected_pm.stat_changed.connect( _on_stat_changed )

func _on_stat_changed(combatant: PlayerCombatant) -> void:
	level_value_label.set_text( str(curr_inspected_pm.curr_level) )
