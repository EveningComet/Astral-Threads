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

func get_party_count() -> int:
	return active_party.size()

func has_party_members() -> bool:
	return active_party.size() > 0
