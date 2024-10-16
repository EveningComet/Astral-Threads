## Holds skills that a character can use.
class_name SkillHolder

## Container for the skills that a character has unlocked or may use.
var skills: Array[SkillData] = []

func add_skill(sd: SkillData) -> void:
	skills.append(sd)

func remove_skill(sd: SkillData) -> void:
	if skills.has(sd) == true:
		skills.erase(sd)

func get_usable_skills() -> Array[SkillData]:
	var to_return: Array[SkillData] = []
	for s: SkillData in skills:
		if s.is_passive == false:
			to_return.append(s)
	return to_return
