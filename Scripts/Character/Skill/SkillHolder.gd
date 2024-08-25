## Holds skills that a character can use.
class_name SkillHolder

var skills: Array[SkillData] = []

func get_usable_skills() -> Array[SkillData]:
	var to_return: Array[SkillData] = []
	for s: SkillData in skills:
		if s.is_passive == false:
			to_return.append(s)
	return to_return
