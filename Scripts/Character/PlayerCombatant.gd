## A version of the combatant component that keeps track of data relevant to
## player characters.
class_name PlayerCombatant extends Combatant

signal experience_gained(growth_data: Array)

var char_name: String:
	get: return char_name
	set(value):
		char_name = value

# TODO: Multiclassing.
var curr_job: Job

var equipment_holder: EquipmentHolder = EquipmentHolder.new(self)

# XP Data
var experience_growth_percentage: float = 1.10
var curr_level: int = 1
var curr_xp:    int = 0
var xp_required:     int = get_experience_required(curr_level)
var total_experience_points: int = 0

## The points for boosting one of this character's skills or class levels.
var available_skill_points:     int = 0

## The points for boosting one of the three core attributes.
var available_attribute_points: int = 0

## Initialize the starting stats based on the passed job.
func initialize_with_job(job_data: Job) -> void:
	curr_job = job_data
	stats.initialize_with_job(curr_job)

## Return how much experience is required for this character to level up.
## Calculation is: 100 * (growth_percent^( current level - 1))
func get_experience_required(level: int) -> int:
	return round( 100 * pow(experience_growth_percentage, level - 1) )

## Give this character experience points.
func gain_experience(gain_amount: int) -> void:
	total_experience_points += gain_amount
	curr_xp += gain_amount
	var growth_data: Array = []
	
	# While the experience is high enough, keep leveling up.
	while curr_xp >= xp_required:
		curr_xp -= xp_required
		growth_data.append( [xp_required, xp_required] )
		level_up()
	growth_data.append( [curr_xp, xp_required] )
	
	# Notify anything about the change in experience
	experience_gained.emit( growth_data )

## Boost this character's level.
func level_up() -> void:
	
	# Boost the level and the required experience for the next level
	curr_level += 1
	xp_required = get_experience_required( curr_level )
	
	# Boost the attributes based on the primary class
	stats.raise_base_value_by(
		StatHelper.StatTypes.Vitality,
		curr_job.vitality_growth
	)
	stats.raise_base_value_by(
		StatHelper.StatTypes.Technique,
		curr_job.technique_growth
	)
	stats.raise_base_value_by(
		StatHelper.StatTypes.Will,
		curr_job.will_growth
	)
