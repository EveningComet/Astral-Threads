## Works as an interface between the instance of a skill and the ui.
class_name SkillNode extends Button

signal upgraded(skill_node: SkillNode)

## The skill that this button is tied to.
@export var associated_skill: SkillData

@export_category("Visuals")
## Visual representation of what skill is stored in this button.
@export var display_icon: TextureRect

## Used to display the current rank to the player.
@export var rank_label: Label

@export var active_color:   Color = Color.WHITE
@export var inactive_color: Color = Color.WHITE

## Used to display the branches to the player.
@export var line_2d: Line2D

## The skill instance that should be paired with the attached skill.
var skill_instance: SkillData

func _ready() -> void:
	get_tree().root.size_changed.connect( on_resolution_changed )
	set_associated_skill(associated_skill)
	if get_parent() is SkillNode:
		draw_point_to(get_parent().global_position + size / 2)
	
	button_down.connect( on_skill_button_down )
	mouse_entered.connect( on_mouse_entered )
	mouse_exited.connect( on_mouse_exited )

func set_associated_skill(new_skill: SkillData) -> void:
	associated_skill = new_skill
	if associated_skill.is_starting_skill == true:
		rank_label.set_text("%s / %s" % [1, str(associated_skill.max_rank)])
	else:
		update_rank_label(0)
	
	display_icon.set_texture(associated_skill.display_texture)
	turn_off()

func set_instanced_skill(instance: SkillData) -> void:
	skill_instance = instance
	update_rank_label(skill_instance.curr_rank)

## Make the line draw to another node.
func draw_point_to(point_to: Vector2) -> void:
	line_2d.add_point(global_position + size / 2)
	line_2d.add_point(point_to)

func update_rank_label(new_rank: int) -> void:
	rank_label.set_text("%s / %s" % [str(new_rank),
		str(associated_skill.max_rank)])

func turn_off() -> void:
	disabled = true
	display_icon.self_modulate = inactive_color

func turn_on() -> void:
	disabled = false
	display_icon.self_modulate = active_color

## Works as a mediator to handle upgrades.
func on_skill_button_down() -> void:
	upgraded.emit(self)

## Fired when the viewport size changes.
func on_resolution_changed() -> void:
	if line_2d.points.size() > 0:
		line_2d.set_point_position(0, global_position + size / 2)
		line_2d.set_point_position(1, get_parent().global_position + size / 2)

func upgrade() -> void:
	if skill_instance.is_max_rank() == true:
		return
		
	skill_instance.upgrade()
	update_rank_label( skill_instance.curr_rank )
	
	# See what nodes should be unlocked
	for c in get_children():
		if c is SkillNode:
			var n = c as SkillNode
			if skill_instance.curr_rank >= n.associated_skill.minimum_rank_of_previous:
				n.turn_on()

func downgrade() -> void:
	skill_instance.downgrade()
	update_rank_label( skill_instance.curr_rank )
	
	# See what nodes need to be relocked
	for c in get_children():
		if c is SkillNode:
			var n = c as SkillNode
			if skill_instance.curr_rank < n.associated_skill.minimum_rank_of_previous:
				n.turn_off()

func on_mouse_entered() -> void:
	#Eventbus.on_tooltip_needed(self)
	pass

func on_mouse_exited() -> void:
	#Eventbus.tooltip_hide.emit()
	pass
