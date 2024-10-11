## Used to help set actions for a player's character.
class_name BattleActionButton extends Button
# TODO: Better name for skills outside of combat?

## Used to help certain UI elements know when this is being focused.
signal skill_button_highlighted(s: SkillData)

## Fired when the player selects this button.
signal action_selected(selected_action: BattleActionButton)

## What kind of action does this button represent?
@export var action_type: ActionTypes.ActionTypes = ActionTypes.ActionTypes.SingleEnemy

var skill: SkillData:
	get: return skill
	set(value):
		skill = value
		if skill != null:
			text        = skill.localization_name
			action_type = skill.action_type
			focus_entered.connect( on_focused )
			mouse_entered.connect( on_mouse_entered )

func _ready() -> void:
	pressed.connect( on_pressed )

func on_pressed() -> void:
	action_selected.emit( self )

func on_focused() -> void:
	skill_button_highlighted.emit( skill )

func on_mouse_entered() -> void:
	skill_button_highlighted.emit( skill )
