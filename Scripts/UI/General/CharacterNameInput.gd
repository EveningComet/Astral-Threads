## Handles entering a name for a player character.
class_name CharacterNameInput extends Control

## Fired when the player finishes naming/renaming a character.
signal name_entered()

@export var name_entry: LineEdit
@export var randomize_name_button: Button = null
@export var accept_name_button:    Button = null

var curr_pc: PlayerCombatant

var previous_name: String = ""

func _ready() -> void:
	name_entry.text_submitted.connect( on_text_submitted )

## Fired when the player hits the enter key.
func on_text_submitted(new_name: String) -> void:
	# Make sure the player has at least one thing entered for a name
	if name_entry.text.length() < 1:
		return
	pass

## Select a name based on whether or not the character is male or female.
func on_randomize_name_button_pressed() -> void:
	var name: String = "Name"
	name_entry.set_text(name)
	previous_name = name
