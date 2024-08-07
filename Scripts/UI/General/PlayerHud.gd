## Responsible for displaying the party's vitals to the player.
class_name PlayerHud extends CanvasLayer

## Prefab of the object used to display a party member to the player.
@export var party_member_slot_scene: PackedScene

@export var party_container: Container

func _ready() -> void:
	setup()

func setup() -> void:
	for pm: PlayerCombatant in PlayerPartyController.get_party():
		if pm != null:
			var pm_slot: PartyMemberSlot = party_member_slot_scene.instantiate()
			pm_slot.set_player_character(pm)
			party_container.add_child(pm_slot)
