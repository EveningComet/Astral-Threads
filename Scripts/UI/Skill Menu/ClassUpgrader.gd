## Deals with upgrading the class.
class_name ClassUpgrader extends Node
# TODO: Make this work more like a CharacterUpgrader or just ClassUpgrader

signal class_upgraded(class_upgraded: ClassUpgrader)

@export var info_container: VBoxContainer
@export var upgrade_button: Button
@export var upgrader: AttributesUpgrader

var info_labels:= {}
var class_name_label: Label

var current_character: PlayerCombatant
var current_class:     Job

## Caching the current skill tree to easily pass along class upgrades.
var curr_skill_tree: SkillTree

func initialize(
	_character_changed_signal: Signal,
	_class_changed_signal:     Signal,
	_points_available_signal:  Signal
	) -> void:
	_character_changed_signal.connect( update_character )
	_class_changed_signal.connect( update_and_render )
	_points_available_signal.connect( toggle_upgrade )
	upgrade_button.button_down.connect( upgrade_class )
	upgrader.class_upgraded.connect( update_class_name_label )
	upgrader.stats_undone.connect( update_class_name_label )
	spawn_labels_for_attributes()

func update_character(new_character: PlayerCombatant) -> void:
	current_character = new_character

func update_and_render(_class: Job):
	current_class = _class
	update_info_labels()

func toggle_upgrade(points_available: int) -> void:
	if points_available == 0:
		upgrade_button.disabled = true
	else:
		upgrade_button.disabled = false

func upgrade_class():
	class_upgraded.emit(self)
	update_class_name_label()

func update_info_labels():
	update_class_name_label()
	for attribute in StatHelper.attributes:
		info_labels[attribute].text = "> " + StatHelper.stat_types_to_string(attribute)
		info_labels[attribute].text += " on upgrade: "
		info_labels[attribute].text += str( 
			current_class.get_upgrade_attributes()[attribute]
		)

func update_class_name_label():
	class_name_label.text = "Class: "
	class_name_label.text += str( current_class.localization_name ).to_upper()
	class_name_label.text += "- Lvl: "
	class_name_label.text += str( current_character.pc_classes[current_class] )

func spawn_labels_for_attributes():
	class_name_label = Label.new()
	info_container.add_child( class_name_label )
	for attribute in StatHelper.attributes:
		var label := Label.new()
		info_labels[attribute] = label
		info_container.add_child( label )
