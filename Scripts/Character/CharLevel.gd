## Stores a character's level.
class_name CharLevel extends Resource

## Fired whenever this character gains experience points.
signal experience_gained(growth_data: Array)

# XP Data
@export var curr_level:              int = 1
var experience_growth_percentage: float = 1.10
var curr_xp:                 int = 0
var xp_required:             int = get_experience_required(curr_level)
var total_experience_points: int = 0

func _init(starting_level: int = 1) -> void:
	curr_level = starting_level

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
	
	# TODO: Boost the attributes based on the creature's growth data
