class_name SkillTypes

## Describes what the main "point" of a skill is. This assists the AI with
## making a decision. It could also be used for sanity checks.
enum SkillTypes {
	DamageSingleEnemy,
	DamageAllEnemies,
	HealSingleAlly,
	HeallAllAllies,
	ApplyStatusEffectToEnemy,
	ApplyStatusEffectToAllEnemies,
	ApplyStatusEffectToSingleAlly,
	ApplyStatusEffectToAllAllies,
	ReviveAlly
}
