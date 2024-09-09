## Handles entering a name for a player character.
class_name CharacterNameInput extends Control

## Fired when the player finishes naming/renaming a character.
signal name_entered()

@export var name_entry: LineEdit
@export var randomize_name_button: Button = null
@export var accept_name_button:    Button = null

var curr_pc: PlayerCombatant = null

var previous_name: String = ""

func _ready() -> void:
	name_entry.text_submitted.connect( on_text_submitted )
	randomize_name_button.pressed.connect( on_randomize_name_button_pressed )

func start_accepting_name(new_char: PlayerCombatant) -> void:
	curr_pc = new_char
	show()

## Fired when the player hits the enter key.
func on_text_submitted(new_name: String) -> void:
	# Make sure the player has at least one thing entered for a name
	if name_entry.text.length() < 1:
		return
	
	curr_pc.char_name = new_name
	curr_pc = null
	hide()
	name_entry.clear()
	name_entered.emit()

##
func on_randomize_name_button_pressed() -> void:
	var name: String = Database.get_male_name()
	if Database.is_male_portrait(curr_pc.portrait_data) == true:
		name = Database.get_male_name()
		while previous_name == name:
			name = Database.get_male_name()
	if Database.is_female_portrait(curr_pc.portrait_data) == true:
		name = Database.get_female_name()
		while previous_name == name:
			name = Database.get_female_name()
	name_entry.set_text(name)
	previous_name = name
