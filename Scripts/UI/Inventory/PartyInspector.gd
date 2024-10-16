## Responsible for displaying the current party and their stats to the player.
class_name PartyInspector extends Control

## Fired whenever the player changes the character they're looking at.
signal displayed_character_changed(new_char: PlayerCombatant)

## The UI component that will handle displaying a party member's equipment to the player.
@export var equipment_displayer: InventoryDisplayer

@export var attributes_container: Container

@export var stat_displayer_prefab: PackedScene

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
		curr_inspected_pm.stat_changed.disconnect( _on_stat_changed )
		equipment_displayer.clear_inventory()
	
	curr_inspected_pm = new_pm
	update_attributes()
	curr_inspected_pm.stat_changed.connect( _on_stat_changed )
	mark_active_member(curr_inspected_pm)
	
	# Update the equipment displayer to match
	equipment_displayer.set_inventory_to_display(curr_inspected_pm.equipment_holder)
	
	# Notify anything about the changes
	displayed_character_changed.emit(curr_inspected_pm)

## Whenever a stat has changed, update to reflect the values.
func _on_stat_changed(combatant: PlayerCombatant) -> void:
	update_attributes()

func update_attributes() -> void:
	for c in attributes_container.get_children():
		c.queue_free()
	
	for attribute in StatHelper.attributes:
		var stat_displayer: StatDisplayer = stat_displayer_prefab.instantiate()
		stat_displayer.update_display(
			str(StatHelper.StatTypes.keys()[attribute]),
			str(curr_inspected_pm.stats.get_calculated_value(attribute))
		)
		attributes_container.add_child(stat_displayer)

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
