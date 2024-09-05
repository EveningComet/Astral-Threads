## Handles the clean up for a battle.
class_name EndBattle extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	clean_up()

func clean_up() -> void:
	Globals.is_movement_disabled = false
	
	# If the player won, give them rewards
	Eventbus.battle_ended.emit()
	my_state_machine.active_enemies.clear()
	
	Eventbus.toggle_mouse.emit(false)
	
	# TODO: Proper winning and losing
	# Give the player experience points
	reward_experience()
	
	# The battle is finally done. Return to default state
	my_state_machine.change_to_state("AwaitingBattleStart")

func reward_experience() -> void:
	var xp: int = my_state_machine.xp_to_reward
	PlayerPartyController.give_experience(xp)
	xp = 0
	my_state_machine.xp_to_reward = 0
