## Visual representation of a party member.
class_name PartyMemberSlot extends PanelContainer

# Vitals
@export var hp_bar: Vitalbar
@export var sp_bar: Vitalbar

@export var char_name_label: Label

## The attached player character.
var player_character: PlayerCombatant

func set_player_character(pc: PlayerCombatant) -> void:
	player_character = pc
	
	# When the player character exists, display the relevant information to the player
	if player_character != null:
		player_character.stat_changed.connect( on_stat_changed )
		char_name_label.set_text(pc.char_name)
		char_name_label.show()
		hp_bar.show()
		sp_bar.show()
		on_stat_changed(player_character)

## When the stats of the monitored character changes, update the vital bars.
func on_stat_changed(pc: Combatant) -> void:
	var curr_health: int = player_character.stats.get_curr_hp()
	var max_health:  int = player_character.stats.get_max_hp()
	var curr_sp:     int = player_character.stats.get_curr_sp()
	var max_sp:      int = player_character.stats.get_max_sp()
	
	hp_bar.update_display(curr_health, max_health)
	sp_bar.update_display(curr_sp, max_sp)
