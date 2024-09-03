## Defines a state the battle manager can be in.
class_name BattleState extends State

## Get all the current characters participating in battle.
func get_all_active_combatants() -> Array[Combatant]:
	var to_return: Array[Combatant]
	to_return.append_array(my_state_machine.active_enemies)
	to_return.append_array(PlayerPartyController.get_party())
	return to_return
