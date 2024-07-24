## Handles visually displaying the player's party in the new game menu.
class_name NGMPartyVisualizer extends Node

@export var party_member_slot_prefab: PackedScene
@export var active_party_container: Container

func _ready() -> void:
	create_party_slots()
	active_party_container.get_child(0).grab_focus()

func create_party_slots() -> void:
	for i in PlayerPartyController.MAX_PMS_IN_ACTIVE_PARTY:
		var pm_ui_slot: PartyMemberSlot = party_member_slot_prefab.instantiate()
		active_party_container.add_child(pm_ui_slot)
