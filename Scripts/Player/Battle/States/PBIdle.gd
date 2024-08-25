## The default state. This is when the game is waiting for the player's turn or
## a battle to start.
class_name PBIdle extends PlayerBattleState

func enter(msgs: Dictionary = {}) -> void:
	Eventbus.player_turn_started.connect( on_player_turn_started )

func exit() -> void:
	Eventbus.player_turn_started.disconnect( on_player_turn_started )

func on_player_turn_started() -> void:
	my_state_machine.setup_for_new_turn()
	my_state_machine.change_to_state("PBSelectAction")
