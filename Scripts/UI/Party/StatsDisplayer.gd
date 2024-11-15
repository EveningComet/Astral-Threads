## Responsible for displaying a character's stats to the player.
class_name StatsDisplayer extends PanelContainer

## Prefab of the [StatDisplayer] object.
@export var stat_displayer_prefab: PackedScene

@export_category("Containers")
@export var attributes_container:    Container
@export var derived_stats_container: Container

## The current party member the player is looking at.
var _curr_pm: PlayerCombatant = null

func update_current_pm(new_pm: PlayerCombatant) -> void:
	if _curr_pm != null:
		_curr_pm.stat_changed.disconnect( _on_stat_changed )
	
	_curr_pm = new_pm
	_curr_pm.stat_changed.connect( _on_stat_changed )
	_on_stat_changed(_curr_pm)

## Whenever a stat has changed, update to reflect the values.
func _on_stat_changed(combatant: PlayerCombatant) -> void:
	_update_attributes()
	_update_derived_stats()

func _update_attributes() -> void:
	for c in attributes_container.get_children():
		c.queue_free()
	
	for attribute in StatHelper.attributes:
		_spawn_stat_displayer(
			attribute,
			_curr_pm.stats.get_calculated_value(attribute),
			attributes_container
		)

func _update_derived_stats() -> void:
	for c in derived_stats_container.get_children():
		c.queue_free()
	
	for i: int in StatHelper.get_non_attributes_as_list():
		match i:
			StatHelper.StatTypes.CurrentHP, StatHelper.StatTypes.CurrentSP:
				continue
				
			_:
				_spawn_stat_displayer(
					i,
					_curr_pm.stats.get_calculated_value(i),
					derived_stats_container
				)
				
func _spawn_stat_displayer(stat_type: StatHelper.StatTypes, value, container: Container) -> void:
	var stat_displayer: StatDisplayer = stat_displayer_prefab.instantiate()
	stat_displayer.update_display(
		str(StatHelper.StatTypes.keys()[stat_type]),
		str(value)
	)
	container.add_child(stat_displayer)
