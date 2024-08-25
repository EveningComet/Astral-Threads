## Sets up the game for the combat.
class_name BattleStart extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("BattleStart :: Entered.")
	
	match msgs:
		{"enemy_party_data": var enemy_party_data}:
			setup_battle(enemy_party_data)
	
func setup_battle(enemy_party_data: EnemyPartyData) -> void:
	# Disable the player's overworld movement.
	# TODO: Disable the camera as well
	Globals.is_movement_disabled = true
	
	# Setup the enemies
	for ed: EnemyData in enemy_party_data.party:
		var enemy: EnemyCombatant = EnemyCombatant.new()
		# TODO: Initialize the enemy stats properly.
		# TODO: Enemy skills.
		enemy.stats.initialize()
		enemy.portrait = ed.portrait
		my_state_machine.active_enemies.append(enemy)
	
	# Hookup the visuals
	BattleHUD.on_battle_start(
		my_state_machine.active_enemies,
	)
	
	
	# Everything is done, switch to the player's turn
	my_state_machine.change_to_state("PlayerTurn")
