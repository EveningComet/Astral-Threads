## When the player is selecting an action for one of their characters.
class_name PBSelectAction extends PlayerBattleState

## The player needs to be able to use a character's skills.
@export var battle_skills_menu:    BattleSkillsMenu
@export var action_buttons_holder: Container

func enter(msgs: Dictionary = {}) -> void:
	for bab: BattleActionButton in action_buttons_holder.get_children():
		bab.action_selected.connect( on_action_button_selected )
		
		# Disable the skill button if the character has no usable skills
		if bab.action_type == ActionTypes.ActionTypes.UseSkill:
			bab.disabled = curr_combatant.skill_holder.get_usable_skills().size() < 1
	
	action_buttons_holder.show()
	action_buttons_holder.get_child(0).grab_focus()

func exit() -> void:
	for bab: BattleActionButton in action_buttons_holder.get_children():
		bab.action_selected.disconnect( on_action_button_selected )
	
	action_buttons_holder.hide()

func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		
		# Before anything else, make sure the battle menu is closed
		if battle_skills_menu.is_visible() == true:
			battle_skills_menu.close()
			return

func on_action_button_selected(bab: BattleActionButton) -> void:
	# Open the relevant menumy_state_machine
	# Everything else can go straight to the targeting state
	if bab.action_type == ActionTypes.ActionTypes.UseSkill:
		battle_skills_menu.open(my_state_machine.curr_combatant)
		return
	
	var stored_action: StoredAction = StoredAction.new()
	stored_action.activator         = curr_combatant
	stored_action.action_type       = bab.action_type
	my_state_machine.change_to_state("PBSelectTarget", {"stored_action" = stored_action})
