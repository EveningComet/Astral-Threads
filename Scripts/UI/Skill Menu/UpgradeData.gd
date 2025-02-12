## Used as a middleman to handle upgrading of skills, character classes, etc.
class_name UpgradeData extends Resource

var skill_node: SkillNode

## The attached skill, if it exists.
var skill_instance: SkillData

## If this upgraded a class, what was it?
var class_upgraded: Job
