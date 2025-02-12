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

func remove_from_party(pm: PlayerCombatant) -> void:
	for slot: int in active_party.size():
		if active_party[slot] != null and active_party[slot] == pm:
			active_party[slot] = null
			break
	Eventbus.party_composition_changed.emit(active_party)

## Helper function for removing the character at the last index of the party,
## if someone exists.
func remove_last_member() -> void:
	var i: int = active_party.size() - 1
	while i >= 0:
		if active_party[i] != null:
			active_party[i] = null
			break
		i -= 1
	Eventbus.party_composition_changed.emit(active_party)

func get_party() -> Array[PlayerCombatant]:
	return active_party

## Get the party members that can currently be targeted.
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

## "Sorts" the active party to remove spaces between characters.
func cleanup_empty_spaces() -> void:
	for i: int in MAX_PMS_IN_ACTIVE_PARTY:
		var null_idx: int = active_party.find(null)
		active_party.remove_at(null_idx)
		active_party.append(null)
	Eventbus.party_composition_changed.emit(active_party)

## Fully heal the party.
func fully_restore_party() -> void:
	for pm: PlayerCombatant in active_party:
		if pm != null:
			pm.stats.full_restore()
