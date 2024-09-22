## Displays a visual represenation of an enemy in battle.
class_name EnemyBattleSprite extends CombatantHUD

@export var portrait: TextureRect

var curr_hp: int = 0

func set_combatant(new_com: EnemyCombatant) -> void:
	combatant = new_com
	curr_hp   = new_com.stats.get_curr_hp()
	combatant.stat_changed.connect( on_stat_changed )
	portrait.set_texture(combatant.portrait)
	custom_minimum_size = combatant.enemy_data.dimensions

func on_stat_changed(com: Combatant) -> void:
	# TODO: Fix bug where a popup number is created when an enemy dies, showing that they're getting healed.
	var target_hp: int = combatant.stats.get_curr_hp()
	if curr_hp != target_hp:
		var diff: int = target_hp - curr_hp
		diff = absi(diff)
		var status: String
		if curr_hp < target_hp:
			while diff > combatant.stats.get_max_hp():
				diff -= 1
			status = "healing"
		
		NumberPopupHandler.display_number(diff, global_position, status)
	curr_hp = target_hp
	
	if com.stats.get_curr_hp() <= 0:
		queue_free()
