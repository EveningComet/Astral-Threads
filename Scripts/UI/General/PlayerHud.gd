## Responsible for displaying the party's vitals to the player.
class_name PlayerHud extends CanvasLayer

## Prefab of the object used to display a party member to the player.
@export var party_member_slot_scene: PackedScene

@export var party_container: Container

func _ready() -> void:
	setup()

func open() -> void:
	show()

func close() -> void:
	hide()

func setup() -> void:
	hide()
	Eventbus.party_composition_changed.connect( on_party_composition_changed )

## Update the displayed party when changes are made.
func on_party_composition_changed(party: Array[PlayerCombatant]) -> void:
	clear_displayed_party()
	for pm: PlayerCombatant in PlayerPartyController.get_party():
		if pm != null:
			var pm_slot: PartyMemberSlot = party_member_slot_scene.instantiate()
			pm_slot.set_player_character(pm)
			party_container.add_child(pm_slot)

func clear_displayed_party() -> void:
	for c in party_container.get_children():
		c.queue_free()

## Function that returns the active party ui.
func get_party() -> Array[PartyMemberSlot]:
	var to_return: Array[PartyMemberSlot] = []
	for pm: PartyMemberSlot in party_container.get_children():
		to_return.append(pm)
	return to_return
