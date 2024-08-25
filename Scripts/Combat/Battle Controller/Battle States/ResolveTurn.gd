## The state where the game resolves the actions.
class_name ResolveTurn extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	# TODO: Properly implement the resolve turn.
	my_state_machine.change_to_state("EndBattle")
