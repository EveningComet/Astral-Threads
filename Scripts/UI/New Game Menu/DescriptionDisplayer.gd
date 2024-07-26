## Handles displaying text in certain menus.
class_name DescriptionDisplayer extends PanelContainer

@export var description_label: Label

func update_text(text: String) -> void:
	description_label.set_text(text)
