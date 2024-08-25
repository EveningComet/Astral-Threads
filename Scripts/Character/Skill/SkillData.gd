## Skills use a component based design where a list of effects define how a skill
## should work.
class_name SkillData extends Resource

@export_category("Base Info")
@export var localization_name: String = "New Skill"
@export_multiline var localization_description: String = "New description."

@export_category("Definitions")
@export var base_cost: int   = 5
@export var is_passive: bool = false

## Used to help select targets.
@export var action_type: ActionTypes.ActionTypes

## The objects that define a how skill work.
@export var effects: Array[SkillEffect] = []

## Get data that can be used based on the attached effects.
func get_usable_data(activator: Combatant):
	return 0
