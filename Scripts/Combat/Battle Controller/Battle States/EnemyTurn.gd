## All the things related to enemy turns.
class_name EnemyTurn extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("EnemyTurn :: Entered.")
	
	# TODO: Properly implement the enemy turn.
	my_state_machine.change_to_state("ResolveTurn")
