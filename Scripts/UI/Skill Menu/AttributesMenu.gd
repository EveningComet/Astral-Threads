class_name AttributesMenu extends Node

signal attribute_points_depleted
signal attribute_points_available

@export var points_label: Label
@export var container: VBoxContainer
@export var menu_entry_template: PackedScene
@export var upgrader: AttributesUpgrader
@export var confirm_button: Button
@export var undo_button: Button

var character: PlayerCombatant
var draft_points: int = 0

func initialize(_character_changed: Signal):
	_character_changed.connect( update_and_render )
	upgrader.stats_confirmed.connect( confirm )
	upgrader.stats_undone.connect( undo )
	upgrader.attribute_upgraded.connect( attribute_upgraded )
	spawn_entries_for_attributes()

func update_and_render(_character: PlayerCombatant):
	character = _character
	set_draft_points( character.available_attribute_points )

func confirm():
	character.available_attribute_points = draft_points
	set_draft_points( character.available_attribute_points )

func undo():
	set_draft_points( character.available_attribute_points )

func attribute_upgraded():
	set_draft_points( draft_points - 1 )

func set_draft_points(points: int):
	draft_points = points
	emit_correct_signal()
	update_points_label()
	disable_confirm_and_undo_if_no_action_taken()

func emit_correct_signal():
	if draft_points == 0:
		emit_signal( "attribute_points_depleted" )
	elif draft_points > 0:
		emit_signal( "attribute_points_available" )

func update_points_label():
	points_label.text = "Available attribute points: "
	points_label.text += str( draft_points )

func disable_confirm_and_undo_if_no_action_taken():
	var no_action_taken := draft_points == character.available_attribute_points
	confirm_button.disabled = no_action_taken
	undo_button.disabled = no_action_taken

func spawn_entries_for_attributes():
	for attribute in StatHelper.attributes:
		var entry := menu_entry_template.instantiate() as AttributeMenuEntry
		entry.initialize(
			attribute, upgrader, attribute_points_depleted, attribute_points_available )
		container.add_child( entry )
