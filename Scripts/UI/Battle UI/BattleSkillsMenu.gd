## When in battle, this UI handles displaying the skills that a character
## can use to the player.
class_name BattleSkillsMenu extends Control

## Prefab of the action button.
@export var action_button_template: PackedScene

## Node housing the buttons.
@export var spawned_buttons_container: Container

@export var skill_description_label: Label

## This would be the current player character that needs to have an action se.
var skill_user: Combatant

func setup_buttons_for(new_user: Combatant) -> void:
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
			# Disable the button if the character lacks the needed pointss
			var sp_cost: int = s.base_cost
			b.disabled = skill_user.stats.get_curr_sp() < sp_cost
			
			# Finally, add the button
			spawned_buttons_container.add_child(b)
			b.skill_button_highlighted.connect( on_skill_button_highlighted )

## Needs to be called after setup.
func open() -> void:	
	# Display and grab focus
	spawned_buttons_container.get_child(0).grab_focus()
	show()

func close() -> void:
	skill_user = null
	clear_buttons()
	hide()

func get_spawned_buttons() -> Array[BattleActionButton]:
	var to_return: Array[BattleActionButton] = []
	for c in spawned_buttons_container.get_children():
		to_return.append(c)
	return to_return

func on_skill_button_highlighted(s: SkillData) -> void:
	skill_description_label.set_text(s.localization_description)

func clear_buttons() -> void:
	for c in spawned_buttons_container.get_children():
		c.queue_free()
