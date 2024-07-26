## Stores the player's party at a given time.
extends Node

## The maximum number of party members the player can have in their party, not
## including summons.
const MAX_PMS_IN_ACTIVE_PARTY: int = 6

var active_party: Array[PlayerCombatant] = []

func add_to_party(pm: PlayerCombatant) -> void:
	active_party.append(pm)
	Eventbus.party_composition_changed.emit(active_party)

func get_party_count() -> int:
	return active_party.size()

func has_party_members() -> bool:
	return active_party.size() > 0
