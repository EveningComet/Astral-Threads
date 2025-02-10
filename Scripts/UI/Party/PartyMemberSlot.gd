## Visual representation of a party member.
class_name PartyMemberSlot extends CombatantHUD

@export var content_container: Container

@export_category("Contents")
# Vitals + XP
@export var hp_bar: Vitalbar
@export var sp_bar: Vitalbar
@export var xp_bar: ProgressBar

## How long, in seconds, it takes for the xp bar to increase.
@export var xp_process_time: float = 1.0

@export var char_name_label: Label

func set_combatant(pc: PlayerCombatant) -> void:
	combatant = pc
	
	# When the player character exists, display the relevant information to the player
	if combatant != null:
		combatant.stat_changed.connect( _on_stat_changed )
		char_name_label.set_text(pc.char_name)
		combatant.experience_gained.connect( _on_experience_gained )
		_on_stat_changed(combatant)
		
		# Enable the things the player should see
		display_contents(true)
	else:
		display_contents(false)

## When the stats of the monitored character changes, update the vital bars.
func _on_stat_changed(pc: Combatant) -> void:
	var curr_health: int = combatant.stats.get_curr_hp()
	var max_health:  int = combatant.stats.get_max_hp()
	var curr_sp:     int = combatant.stats.get_curr_sp()
	var max_sp:      int = combatant.stats.get_max_sp()
	
	hp_bar.update_display(curr_health, max_health)
	sp_bar.update_display(curr_sp, max_sp)

## When the monitored player character gains experience points, update to show
## the visual change.
func _on_experience_gained(growth_data: Array) -> void:
	for line in growth_data:
		var desired_experience = line[0]
		var max_experience     = line[1]
		xp_bar.max_value       = max_experience
		await animate_xp_bar(desired_experience, xp_process_time)
		if xp_bar.max_value == xp_bar.value:
			# TODO: If an animation/effect/etc. is dresired, play it here.
			xp_bar.value = xp_bar.min_value

func animate_xp_bar(target, duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(xp_bar, "value", target,
	duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished

func display_contents(display: bool) -> void:
	for c in content_container.get_children():
		if display == true:
			c.show()
		else:
			c.hide()
