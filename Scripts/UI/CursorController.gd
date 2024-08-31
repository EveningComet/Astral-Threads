## Handles the cursor.
class_name CursorController extends Node

@export var enemy_container: Container
@export var cursor_prefab: PackedScene

var spawned_cursors: Array[CombatCursor] = []

## For single target actions
var curr_index: int = 0

var target_scan_node: Control = null

func spawn_needed_cursors(new_action: StoredAction) -> void:
	# TODO: Checks to make sure target is valid.
	match new_action.action_type:
		ActionTypes.ActionTypes.SingleEnemy:
			var cursor = cursor_prefab.instantiate()
			spawned_cursors.append(cursor)
			get_parent().add_child(cursor)
			target_scan_node = enemy_container
			set_cursor_target(cursor, target_scan_node.get_child(0))
		
		ActionTypes.ActionTypes.AllEnemies:
			target_scan_node = enemy_container
			for enemy_ui: EnemyBattleSprite in target_scan_node.get_children():
				var cursor = cursor_prefab.instantiate()
				spawned_cursors.append(cursor)
				get_parent().add_child(cursor)
				set_cursor_target(cursor, enemy_ui)
		
		ActionTypes.ActionTypes.SingleAlly:
			var cursor: CombatCursor = cursor_prefab.instantiate()
			target_scan_node = PlayerHUD.party_container
			spawned_cursors.append(cursor)
			set_cursor_target(cursor, target_scan_node.get_child(0))
		
		ActionTypes.ActionTypes.AllAllies:
			target_scan_node = PlayerHUD.party_container
			for pm: PartyMemberSlot in target_scan_node.get_children():
				var cursor: CombatCursor = cursor_prefab.instantiate()
				spawned_cursors.append(cursor)
				get_parent().add_child(cursor)
				set_cursor_target(cursor, pm)

func set_cursor_target(cursor: CombatCursor, battler_ui: CombatantHUD) -> void:
	# Set the target and move the cursor
	var new_target: Combatant = battler_ui.combatant
	cursor.target = new_target
	cursor.global_position = get_center(battler_ui)

## This only accounts for singular targets
func find_closest_target(direction: Vector2) -> void:
	if spawned_cursors.size() > 1:
		return
	
	if direction.x > 0 or direction.y > 0:
		curr_index += 1
	elif direction.x < 0 or direction.y < 0:
		curr_index -= 1
	if curr_index > target_scan_node.get_child_count() - 1:
		curr_index = 0
	elif curr_index < 0:
		curr_index = target_scan_node.get_child_count() - 1
	
	# Set the new target if it is not the same as the old target
	var battler_ui: CombatantHUD = target_scan_node.get_child( curr_index )
	var target: Combatant = battler_ui.combatant
	var cursor = spawned_cursors[0]
	if cursor.target == target:
		return
	
	# Everything is good, so set the new target
	set_cursor_target(cursor, battler_ui)

func get_targets() -> Array[Combatant]:
	var to_return: Array[Combatant] = []
	for cursor: CombatCursor in spawned_cursors:
		to_return.append(cursor.target)
	return to_return

func get_center(node: Control) -> Vector2:
	var center: Vector2 = node.global_position - node.size
	center /= 2.0
	return center

func clear_cursors() -> void:
	for c in spawned_cursors:
		c.queue_free()
	spawned_cursors.clear()
	target_scan_node = null
