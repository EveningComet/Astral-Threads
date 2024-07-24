## Stores the player's party at a given time.
extends Node

## The maximum number of party members the player can have in their party, not
## including summons.
const MAX_PMS_IN_ACTIVE_PARTY: int = 6

var active_party: Array[Combatant] = []

func add_to_party(pm: Combatant) -> void:
	active_party.append(pm)

func get_party_count() -> int:
	return active_party.size()

func has_party_members() -> bool:
	return active_party.size() > 0
