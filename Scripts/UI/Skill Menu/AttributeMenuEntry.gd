class_name AttributeMenuEntry extends HBoxContainer

@export var attribute_label: Label
@export var upgrade_button: Button

var stat_types := StatHelper.StatTypes
var attribute: StatHelper.StatTypes
var upgrader: AttributesUpgrader

func initialize(
	_attribute: StatHelper.StatTypes, _upgrader: AttributesUpgrader,
	_points_depleted: Signal, _points_available: Signal):
	
	attribute = _attribute
	upgrader = _upgrader
	upgrader.draft_stats_changed.connect( update_and_render )
	_points_depleted.connect( disable_upgrade )
	_points_available.connect( enable_upgrade )
	upgrade_button.button_down.connect( upgrade )

func update_and_render(stats: Dictionary):
	update_label( stats[attribute] )

func disable_upgrade():
	upgrade_button.disabled = true

func enable_upgrade():
	upgrade_button.disabled = false

func upgrade():
	upgrader.attribute_upgrade( attribute )

func update_label(points: int):
	attribute_label.text = stat_types.stat_types_to_string[attribute]
	attribute_label.text += ": "
	attribute_label.text += str( points )
