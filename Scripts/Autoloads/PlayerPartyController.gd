## Stores the player's party at a given time.
extends Node

## The maximum number of party members the player can have in their party, not
## including summons.
const MAX_PMS_IN_ACTIVE_PARTY: int = 6

var active_party: Array[PlayerCombatant] = []

func _ready() -> void:
	for i in MAX_PMS_IN_ACTIVE_PARTY:
		active_party.append(null)

func add_to_party(pm: PlayerCombatant) -> void:
	for slot: int in active_party.size():
		if active_party[slot] == null:
			active_party[slot] = pm
			break
	Eventbus.party_composition_changed.emit(active_party)

func get_party() -> Array[PlayerCombatant]:
	return active_party

func get_targetable_party() -> Array[PlayerCombatant]:
	var to_return: Array[PlayerCombatant]
	for pm: PlayerCombatant in get_party():
		if pm != null and pm.stats.get_curr_hp() > 0:
			to_return.append(pm)
	return to_return

func give_experience(xp: int) -> void:
	for pm: PlayerCombatant in get_party():
		if pm != null:
			pm.gain_experience(xp)

## Is there at least one party member with at least 1 hp?
func is_party_fightable() -> bool:
	var status: bool = false
	for pm: PlayerCombatant in active_party:
		if pm != null and pm.stats.get_curr_hp() > 0:
			status = true
			break
	return status
