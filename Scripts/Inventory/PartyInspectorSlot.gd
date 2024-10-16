class_name PartyInspectorSlot extends Control

## Visually represents what character is currently being looked at.
@export var portrait_displayer: PortraitDisplayerPanel

@export var level_value_label: Label

var party_member: PlayerCombatant

func set_party_member(new_pm: PlayerCombatant) -> void:
	if party_member != null:
		party_member.stat_changed.disconnect( _on_stat_changed )
	
	party_member = new_pm
	level_value_label.set_text( str(party_member.curr_level) )
	portrait_displayer.portrait_data = new_pm.portrait_data
	portrait_displayer.display_icon.set_texture(new_pm.portrait_data.small_portrait)
	party_member.stat_changed.connect( _on_stat_changed )

func mark_as_active() -> void:
	portrait_displayer.highlight()

func mark_as_inactive() -> void:
	portrait_displayer.unhighlight()

func _on_stat_changed(combatant: PlayerCombatant) -> void:
	level_value_label.set_text( str(party_member.curr_level) )
