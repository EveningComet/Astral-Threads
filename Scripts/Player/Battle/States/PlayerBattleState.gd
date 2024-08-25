## Manages things for the player during a battle.
class_name PlayerBattleState extends State

var curr_combatant: Combatant:
	get: return my_state_machine.curr_combatant
