## A thing that exists on a character and does something to them.
class_name StatusEffect extends Resource

@export_category("Base Info")
@export var localization_name:                  String = "New Status Effect"
@export_multiline var localization_description: String = "New description."

## Used as a quick and dirty way to check if a character has negative status effects present.
@export var is_negative: bool = false
