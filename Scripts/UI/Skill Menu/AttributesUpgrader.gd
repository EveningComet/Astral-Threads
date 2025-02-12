## Interface for spending attribute points and skill points
class_name AttributesUpgrader extends Node

signal attribute_upgraded
signal class_upgraded

signal stats_confirmed
signal stats_undone
signal draft_stats_changed(new_stats: Dictionary)

var character: PlayerCombatant
var current_class: Job

## Stores the classes and their potentially new levels.
var classes_and_class_levels: Dictionary

## Stores what the player's attributes will be depending on the upgrades.
var draft_stats: Dictionary = {}
var attributes := StatHelper.attributes

func initialize(_character_changed: Signal, _class_changed: Signal):
	_class_changed.connect( set_class )
	_character_changed.connect( store_stats )

func set_class(_new_class: Job):
	current_class = _new_class
	reset_draft_stats()

func store_stats(_character: PlayerCombatant):
	if character != null:
		character.stat_changed.disconnect( on_character_stats_changed )
	character = _character
	character.stat_changed.connect( on_character_stats_changed )
	classes_and_class_levels = character.pc_classes.duplicate()
	reset_draft_stats()

## When the stats of the monitored character change.
func on_character_stats_changed(_character: PlayerCombatant) -> void:
	draft_stats_changed.emit( draft_stats )

func confirm():
	# Upgrade the class level
	for key: Job in classes_and_class_levels:
		var diff: int = classes_and_class_levels[key] - character.pc_classes[key]
		if diff > 0:
			character.upgrade_class_by(key, diff)
	
	# Upgrade the attributes
	for attribute in attributes:
		var draft_val:    int = draft_stats[attribute]
		var original_val: int = character.stats.stats[attribute as StatHelper.StatTypes].get_base_value()
		var diff:         int = draft_val - original_val
		if diff > 0:
			character.raise_base_value_by(attribute, diff)
	
	reset_draft_stats()
	stats_confirmed.emit()

func undo():
	reset_draft_stats()
	stats_undone.emit()

func attribute_upgrade(attribute: StatHelper.StatTypes):
	draft_stats[attribute] += 1
	attribute_upgraded.emit()
	draft_stats_changed.emit(draft_stats)

func class_upgrade(upgrading_class: Job):
	classes_and_class_levels[upgrading_class] += 1
	for attribute in attributes:
		draft_stats[attribute] += upgrading_class.get_upgrade_attributes()[attribute]
	
	# The class is being upgraded, see if there are any skills that can be
	# unlocked for that class
	character.skill_holder.try_to_unlock_with_class_level(
		current_class, classes_and_class_levels[upgrading_class]
	)
	
	class_upgraded.emit()
	draft_stats_changed.emit( draft_stats )

func reset_draft_stats():
	if current_class != null and character != null and character.pc_classes.has(current_class):
		classes_and_class_levels[current_class] = character.pc_classes[current_class]
		for attribute in attributes:
			draft_stats[attribute] = character.stats.stats[attribute].get_base_value()
		
		# TODO: See if some skills have to be relocked.
		
		draft_stats_changed.emit( draft_stats )
