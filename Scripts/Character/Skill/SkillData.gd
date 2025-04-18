## Skills use a component based design where a list of effects define how a skill
## should work.
class_name SkillData extends Resource

@export_category("Base Info")
@export var localization_name:                  String = "New Skill"
@export_multiline var localization_description: String = "New description."
@export var display_texture: Texture2D

## For player characters, is this skill automatically usable from the start?
@export var is_starting_skill: bool = false

@export_category("Definitions")
@export var base_cost:       int  = 5
@export var is_passive:      bool = false
@export var num_activations: int  = 1

## Used to help select targets.
@export var action_type: ActionTypes.ActionTypes

## The objects that define a how skill work.
@export var effects: Array[SkillEffect] = []

## The tier tiers for this skill. Think of this as above rank 1.
@export var tiers: Array[SkillTier] = []

## The max rank is determined by the amount of tiers.
var max_rank: int = 1:
	get:
		return tiers.size()

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
			damage_data.activator = activator.stats
			
			# Get the damage amount
			damage_data.damage_amount          = damage_effect.get_power(activator.stats)
			damage_data.base_power_scale       = damage_effect.power_scale
			damage_data.damage_heal_percentage = damage_effect.attacker_heal_percentage
			modified_action.damage_datas.append(damage_data)
		
		elif e is HealEffect:
			var heal_effect: HealEffect = e as HealEffect
			var healing_power: int = e.get_power(activator.stats)
			modified_action.heal_amount += healing_power
		
		elif e is ApplyStatusEffect:
			var ase:           ApplyStatusEffect = e as ApplyStatusEffect
			var status_effect: StatusEffect      = ase.status_effect
			var chance:        float             = ase.chance_to_apply
			modified_action.status_effects_to_apply[status_effect] = chance
	
	return modified_action
