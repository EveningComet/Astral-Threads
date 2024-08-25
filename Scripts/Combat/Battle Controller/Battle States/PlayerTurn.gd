## Handles functionality related to the player's turn in combat.
class_name PlayerTurn extends BattleStart

func enter(msgs: Dictionary = {}) -> void:
	Eventbus.player_turn_started.emit()
	Eventbus.side_finished_turn.connect( on_player_turn_finished )

func exit() -> void:
	Eventbus.side_finished_turn.disconnect( on_player_turn_finished )

func on_player_turn_finished(stored_actions: Array[StoredAction]) -> void:
	my_state_machine.add_actions( stored_actions )
	my_state_machine.change_to_state("EnemyTurn")
