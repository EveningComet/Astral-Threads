## A simple ui component that displays a stat name and a value somehwere in the UI.
class_name StatDisplayer extends MarginContainer

@export var stat_name_label:  Label
@export var stat_value_label: Label

func update_display(stat_name: String, stat_value: String) -> void:
	stat_name_label.set_text(stat_name)
	stat_value_label.set_text(stat_value)
