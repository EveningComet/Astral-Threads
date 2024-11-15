## Responsible for displaying the current party and their stats to the player.
class_name PartyInspector extends PanelContainer

## Fired whenever the player changes the character they're looking at.
signal displayed_character_changed(new_char: PlayerCombatant)

## UI component that handles displaying a character's stats to the player.
@export var stats_displayer: StatsDisplayer

## The UI component that will handle displaying a party member's equipment to the player.
@export var equipment_displayer: InventoryDisplayer

## The prefab for displaying a party member.
@export var slot_prefab : PackedScene

@export var members_container: Container

var party_member_to_slot : Dictionary = {} 

## The current party member the character is looking at.
var curr_inspected_pm: PlayerCombatant

func _ready() -> void:
	clear_members_container()
	spawn_slots_for_party()

func open() -> void:
	set_pm_to_inspect(PlayerPartyController.get_party()[0])
	show()

func close() -> void:
	hide()

## Set the current party member to look at.
func set_pm_to_inspect(new_pm: PlayerCombatant) -> void:
	if curr_inspected_pm != null:
		equipment_displayer.clear_inventory()
	
	curr_inspected_pm = new_pm
	stats_displayer.update_current_pm( curr_inspected_pm )
	mark_active_member(curr_inspected_pm)
	
	# Update the equipment displayer to match
	equipment_displayer.set_inventory_to_display(curr_inspected_pm.equipment_holder)
	
	# Notify anything about the changes
	displayed_character_changed.emit(curr_inspected_pm)

func clear_members_container() -> void:
	for child in members_container.get_children():
		members_container.remove_child(child)
		child.queue_free()

func spawn_slots_for_party() -> void:
	for member in PlayerPartyController.get_party():
		if (member != null):
			var slot: PartyInspectorSlot = slot_prefab.instantiate()
			slot.portrait_displayer.gui_input.connect(_on_gui_input.bind(member))
			slot.set_party_member(member)
			members_container.add_child(slot)
			party_member_to_slot[member] = slot

func _on_gui_input(event, member: PlayerCombatant):
	if event is InputEventMouseButton and event.is_pressed():
		if (member != curr_inspected_pm):
			set_pm_to_inspect(member)

func mark_active_member(target: PlayerCombatant):
	for member in party_member_to_slot.keys():
		if (member == target):
			(party_member_to_slot[member] as PartyInspectorSlot).mark_as_active()
		else:
			(party_member_to_slot[member] as PartyInspectorSlot).mark_as_inactive()
