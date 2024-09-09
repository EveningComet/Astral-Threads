## Displays a visual represenation of an enemy in battle.
class_name EnemyBattleSprite extends CombatantHUD

@export var portrait: TextureRect

func set_combatant(new_com: EnemyCombatant) -> void:
	combatant = new_com
	combatant.stat_changed.connect( on_stat_changed )
	portrait.set_texture(combatant.portrait)
	custom_minimum_size = combatant.enemy_data.dimensions

func on_stat_changed(com: Combatant) -> void:
	if com.stats.get_curr_hp() <= 0:
		queue_free()
