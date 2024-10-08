## Responsible for managing combat.
class_name BattleController extends StateMachine

## The actions that will be performed during the next resolve phase.
var current_turn_actions: Array[StoredAction] = []

var active_enemies: Array[EnemyCombatant] = []

## References to the enemy world objects. Used to destroy them when the player wins a fight.
var enemy_party_owners: Array[Node3D] = []

var xp_to_reward: int = 0

func set_me_up() -> void:
	# Connect to the event bus so we can now when a battle should start
	Eventbus.start_battle.connect( _on_battle_start )
	Eventbus.hp_depleted.connect( _on_hp_depleted )
	xp_to_reward = 0
	super()

func _on_battle_start(enemy_party_data: EnemyPartyData) -> void:
	# TODO: Checks to see if a battle is already under way.
	
	enemy_party_owners.append(enemy_party_data.get_parent())
	# Time to start the battle
	xp_to_reward = 0
	change_to_state(
		"BattleStart",
		{enemy_party_data = enemy_party_data}
	)

func _on_hp_depleted(com: Combatant) -> void:
	if com is EnemyCombatant and active_enemies.has(com):
		var enemy: EnemyCombatant = com as EnemyCombatant
		xp_to_reward += enemy.enemy_data.xp_on_death
		active_enemies.erase(com)

func add_actions(actions_to_add: Array[StoredAction]) -> void:
	current_turn_actions.append_array(actions_to_add)

func destroy_tracked_world_enemies() -> void:
	for e in enemy_party_owners:
		enemy_party_owners.erase(e)
		e.queue_free()
