## Handles the clean up for a battle.
class_name EndBattle extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	clean_up()

func clean_up() -> void:
	Globals.is_movement_disabled = false
	
	# If the player won, give them rewards
	Eventbus.battle_ended.emit()
	my_state_machine.active_enemies.clear()
	
	# The battle is finally done. Return to default state
	my_state_machine.change_to_state("AwaitingBattleStart")
