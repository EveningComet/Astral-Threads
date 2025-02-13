## Stores a template for a skill tree.
class_name SkillTree extends Control

var existing_skill_nodes: Array[SkillNode]

func _ready() -> void:
	existing_skill_nodes = get_all_existing_nodes_within()

## A quick and dirty way of getting all the skill nodes attached to a skill tree.
func get_all_existing_nodes_within(branch: Control = self) -> Array[SkillNode]:
	var all_contained_skill_nodes: Array[SkillNode] = []
	for n in branch.get_children():
		if n is SkillNode:
			all_contained_skill_nodes.append(n)
		if n.get_child_count() > 0:
			all_contained_skill_nodes.append_array( get_all_existing_nodes_within(n) )
	return all_contained_skill_nodes

## Taking a collection of instanced skills, hook them up with the correct skill.
func combine_instances_to_nodes(instanced_skills: Array[SkillData]) -> void:
	var temp: Array[SkillNode]
	temp.append_array(existing_skill_nodes)
		
	for instance: SkillData in instanced_skills:
		for n: SkillNode in temp:
			if instance.skill == n.associated_skill:
				n.set_instanced_skill(instance)
				temp.erase(n)
				continue

## Go through the stored nodes and see which ones can accept upgrades.
func update_upgradability_status(combatant: PlayerCombatant) -> void:
	var available_skill_points: int = combatant.available_skill_points
	for n: SkillNode in existing_skill_nodes:
		# Criteria that needs to be met to allow upgrading/using a skill
		var meets_class_level:          bool = false
		var meets_previous_skill_level: bool = false
		
		if n.associated_skill.is_starting_skill == true:
			meets_class_level          = true
			meets_previous_skill_level = true
		
		if n.get_parent() is SkillNode:
			var parent_n: SkillNode = n.get_parent()
			if parent_n.skill_instance.curr_rank >= n.associated_skill.minimum_rank_of_previous:
				meets_previous_skill_level = true
		
		# Check if the character class meets the requirement
		for cc: Job in combatant.pc_classes.keys():
			if cc.skills.has(n.associated_skill) == true:
				# TODO: This is not working properly.
				var class_level: int = combatant.pc_classes[cc]
				if class_level >= n.associated_skill.unlocks_at_class_level:
					meets_class_level = true
		
		if meets_class_level == true and meets_previous_skill_level == true:
			n.turn_on()
		else:
			n.turn_off()
