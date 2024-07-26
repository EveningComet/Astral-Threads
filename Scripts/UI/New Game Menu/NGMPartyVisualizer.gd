## Handles visually displaying the player's party in the new game menu.
class_name NGMPartyVisualizer extends Node

@export var party_member_slot_prefab: PackedScene
@export var active_party_container: Container

func _ready() -> void:
	Eventbus.party_composition_changed.connect( on_party_composition_changed )
	clear_slots()
	create_party_slots()
	active_party_container.get_child(0).grab_focus()

func clear_slots() -> void:
	for c in active_party_container.get_children():
		c.queue_free()

func create_party_slots() -> void:
	for i in PlayerPartyController.MAX_PMS_IN_ACTIVE_PARTY:
		var pm_ui_slot: PartyMemberSlot = party_member_slot_prefab.instantiate()
		active_party_container.add_child(pm_ui_slot)

func update_slots() -> void:
	# Go through the player's party and update the slots
	# based on the characters
	var pm_slots: Array = active_party_container.get_children()
	for pc: PlayerCombatant in PlayerPartyController.active_party:
		var pm_slot: PartyMemberSlot = pm_slots[0]
		if pc != null:
			pm_slot.set_player_character(pc)
		else:
			pm_slot.set_player_character(null)
		pm_slots.remove_at(0)
	
	# Clean up any remaining slots
	for slot in pm_slots:
		slot.set_player_character(null)

func on_party_composition_changed(party: Array[PlayerCombatant]) -> void:
	if OS.is_debug_build() == true:
		print("NGMPartyVisualizer :: Party composition changed.")
		
	update_slots()
