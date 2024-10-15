## Works as an interface between the instance of a skill and the ui.
class_name SkillNode extends Button

## Fired when this skill node has been unlocked.
signal unlocked(skill_node: SkillNode)

## The skill this node keeps track of.
@export var associated_skill: SkillData

## Used to help visually represent what skill is stored in this button.
@export var display_icon: TextureRect

@export var active_color:   Color = Color.WHITE
@export var inactive_color: Color = Color.WHITE

## Used to display the branches to the player.
@export var line_2d: Line2D

func _ready() -> void:
	button_down.connect( on_skill_button_down )

func on_skill_button_down() -> void:
	unlock()

## Used to unlock the attached skill.
func unlock() -> void:
	unlocked.emit( self )

## Locks the skill.
func lock() -> void:
	pass
