## Visual representation of a party member.
class_name PartyMemberSlot extends PanelContainer

# Vitals
@export var hp_bar: ProgressBar
@export var sp_bar: ProgressBar

@export var char_name_label: Label

## The attached player character.
var player_character: PlayerCombatant

func set_player_character(pc: PlayerCombatant) -> void:
	player_character = pc
	if player_character != null:
		char_name_label.show()
