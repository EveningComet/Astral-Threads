class_name BattleSkillsMenu extends Control

@export var action_button_template: PackedScene

## Node housing the buttons.
@export var spawned_buttons_container: Container

## This would be the current player character that needs to have an action se.
var skill_user: Combatant

func open(new_user: Combatant) -> void:
	if skill_user != null:
		clear_buttons()
		
	skill_user = new_user
	var skill_holder = skill_user.skill_holder
	if skill_holder.get_usable_skills().size() > 0:
		for s: SkillData in skill_holder.get_usable_skills():
			# Create the button and set the skill
			var b: BattleActionButton = action_button_template.instantiate()
			b.skill = s
			
			# TODO: Account for skills that lower cost.
			var sp_cost: int = s.base_cost
			b.disabled = skill_user.stats.get_curr_sp() < sp_cost
			
			# Finally, add the button
			spawned_buttons_container.add_child(b)
	
	# Display and grab focus
	spawned_buttons_container.get_child(0).grab_focus()
	show()

func close() -> void:
	skill_user = null
	clear_buttons()
	hide()

func on_skill_button_highlighted(s: SkillData) -> void:
	# TODO: Display the skill information the player.
	pass

func clear_buttons() -> void:
	for c in spawned_buttons_container.get_children():
		c.queue_free()
