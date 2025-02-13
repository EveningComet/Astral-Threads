## Controls all aspects of the skills menu.
class_name SkillMenuController extends Node

signal skill_points_available(points: int)
signal character_changed(character: PlayerCombatant)
signal class_changed(new_class: Job)

@export var tree_container: Container

@export var character_tab_bar: TabBar
@export var class_tabs:  TabBar
@export var exit_button: Button
@export var undo_skill_points_button: Button
@export var skill_points_label: Label
@export var canvas: CanvasLayer
@export var attributes_menu: AttributesMenu
@export var class_upgrader: ClassUpgrader
@export var attributes_upgrader: AttributesUpgrader

var characters:= PlayerPartyController.active_party
var current_character: PlayerCombatant
var draft_available_skill_points: int = 0:
	get: return draft_available_skill_points
	set(value):
		draft_available_skill_points = value
		skill_points_available.emit(draft_available_skill_points)
		update_draft_skill_points_label()

## Stores the recent history of the skill points the player has alloted.
var alloted_history: Array[UpgradeData] = []

func _ready() -> void:
	setup()

func setup() -> void:
	add_tabs_per_character()
	undo_skill_points_button.pressed.connect( on_undo_skill_points_button_pressed )
	character_tab_bar.tab_changed.connect( on_character_tab_changed )
	class_tabs.tab_changed.connect( on_character_class_tab_changed )
	canvas.visibility_changed.connect( on_visibility_changed )
	
	# Get the components ready
	class_upgrader.initialize(
		character_changed, class_changed, skill_points_available
	)
	class_upgrader.class_upgraded.connect( on_upgrade_occurred )

func add_tabs_per_character():
	character_tab_bar.clear_tabs()
	for character in characters:
		if character == null:
			continue
		var tab_name = character.char_name
		character_tab_bar.add_tab( tab_name )

func on_visibility_changed():
	if canvas.visible == true:
		on_character_tab_changed( character_tab_bar.current_tab )
	else:
		if current_character != null:
			current_character.available_skill_points = draft_available_skill_points
		alloted_history.clear() # Make any previously set upgrades permanent

func on_character_tab_changed(index: int):
	if PlayerPartyController.has_members() == true:
		# Refresh the alloted history and delete the old tree(s)
		alloted_history.clear()
		if tree_container.get_child_count() > 0:
			for c in tree_container.get_children():
				c.queue_free()
		
		if current_character != null:
			current_character.available_skill_points = draft_available_skill_points
		class_tabs.clear_tabs()
		current_character = characters[index]
		draft_available_skill_points = current_character.available_skill_points
		
		undo_skill_points_button.disabled = true if draft_available_skill_points == 0 else false
		
		# Create the needed tabs for character classes
		for cc: Job in current_character.pc_classes:
			var tab_name = cc.localization_name
			class_tabs.add_tab( tab_name )
		on_character_class_tab_changed(0)

## When the player changes a tab related to a character's class, show the
## proper skills.
func on_character_class_tab_changed(index: int) -> void:
	if tree_container.get_child_count() > 0:
		for c in tree_container.get_children():
			c.queue_free()
	
	var classes_as_array: Array = current_character.pc_classes.keys()
	var desired_class: Job = classes_as_array[index]
	var class_skill_tree: SkillTree = desired_class.skill_tree_prefab.instantiate()
	await get_tree().process_frame
	tree_container.add_child(class_skill_tree)
	var scroll_container = tree_container as ScrollContainer
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
	
	# Hook up the skill instances
	var instances = get_skill_instances_of_class(desired_class)
	class_skill_tree.combine_instances_to_nodes(instances)
	class_skill_tree.update_upgradability_status(current_character)
	
	# Connect to the upgrade events
	var existing_skill_nodes = class_skill_tree.existing_skill_nodes
	for n: SkillNode in existing_skill_nodes:
		n.upgraded.connect( on_upgrade_occurred )
	
	# Everything is finished, notify everything that needs to know about the
	# character and/or class changes
	character_changed.emit( current_character )
	class_changed.emit(desired_class)

## Get the skills of the class for the current character.
func get_skill_instances_of_class(desired_class: Job) -> Array[SkillData]:
	var class_skills: Array[SkillData] = []
	for s: SkillData in current_character.skill_holder.skills:
		if desired_class.skills.has(s.skill) == true:
			class_skills.append(s)
	return class_skills

func update_draft_skill_points_label():
	skill_points_label.text = "Available skill points: "
	skill_points_label.text += str( draft_available_skill_points )

## Handle what should happen when an upgrade happens here.
func on_upgrade_occurred(upgradable: Object) -> void:
	if draft_available_skill_points == 0:
		return
		
	var upgrade_data: UpgradeData = UpgradeData.new()
	if upgradable is SkillNode:
		var skill_node = upgradable as SkillNode
		if skill_node.skill_instance.curr_rank == skill_node.associated_skill.max_rank:
			return
		skill_node.upgrade()
		upgrade_data.skill_node = skill_node
		upgrade_data.skill_instance = skill_node.skill_instance
	if upgradable is ClassUpgrader:
		upgrade_data.class_upgraded = class_upgrader.current_class
		current_character.upgrade_class_and_self_handle_upgrades(
			upgrade_data.class_upgraded, 1
		)
	
	alloted_history.append(upgrade_data)
	draft_available_skill_points -= 1

## When the player selects the undo button, revert all the upgrades the player
## stored. Go through the list of stored upgrades and reverse them.
func on_undo_skill_points_button_pressed() -> void:
	# Go through the alloted history and undo the upgrades the player made
	while alloted_history.is_empty() == false:
		var upgrade_to_remove = alloted_history.pop_back()
		if upgrade_to_remove.skill_instance != null:
			var skill_node: SkillNode = upgrade_to_remove.skill_node
			skill_node.downgrade()
		elif upgrade_to_remove.class_upgraded != null:
			current_character.downgrade_class(upgrade_to_remove.class_upgraded)
			class_changed.emit(upgrade_to_remove.class_upgraded)
		draft_available_skill_points += 1
