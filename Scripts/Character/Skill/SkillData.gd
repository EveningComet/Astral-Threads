## Skills use a component based design where a list of effects define how a skill
## should work.
class_name SkillData extends Resource

@export_category("Base Info")
@export var localization_name:                  String = "New Skill"
@export_multiline var localization_description: String = "New description."

@export_category("Definitions")
@export var base_cost:       int  = 5
@export var is_passive:      bool = false
@export var num_activations: int  = 1

## Used to help select targets.
@export var action_type: ActionTypes.ActionTypes

## The objects that define a how skill work.
@export var effects: Array[SkillEffect] = []

## Modify the passed action based on the skill user and the skill effects.
func get_usable_data(activator: Combatant, action: StoredAction) -> StoredAction:
	var modified_action: StoredAction = action
	modified_action.num_activations = num_activations
	modified_action.damage_datas.clear()
	for e: SkillEffect in effects:
		
		if e is DamageEffect:
			# Create and add the damage data
			var damage_effect: DamageEffect = e as DamageEffect
			var damage_data:   DamageData   = DamageData.new()
			damage_data.damage_type = damage_effect.damage_type
			damage_data.damage_amount = 5 # TODO: Get the power output
			damage_data.base_power_scale = damage_effect.power_scale
			damage_data.damage_heal_percentage = damage_effect.attacker_heal_percentage
			modified_action.damage_datas.append(damage_data)
		
		elif e is HealEffect:
			var heal_effect: HealEffect = e as HealEffect
			var special_power: int = activator.stats.get_special_power()
			var healing_power: int = floor(e.power_scale * special_power)
			modified_action.heal_amount += healing_power
		
		elif e is ApplyStatusEffect:
			var ase: ApplyStatusEffect = e as ApplyStatusEffect
			modified_action.status_effects_to_apply[ase] = ase.chance_to_apply
	
	return modified_action
