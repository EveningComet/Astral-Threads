## State for where we are waiting for user to select which character to remove
class_name NGMSRemoveMember extends NewGameMenuState

@export var new_character_button:    Button
@export var remove_character_button: Button
@export var manage_party_buttons_container: Container

var _old_text_new_character_button : String

func enter(msgs: Dictionary = {}) -> void:
	_old_text_new_character_button = new_character_button.text
	new_character_button.text = "Back"
	
	active_party_container.show()
	manage_party_buttons_container.show()
	new_character_button.pressed.connect( _on_new_character_button_pressed )
	remove_character_button.hide()
	
	for slot in active_party_container.get_children():
		if slot is PartyMemberSlot:
			slot.gui_input.connect(_on_party_member_slot_clicked.bind(slot))

func _on_party_member_slot_clicked(event, slot: PartyMemberSlot) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		PlayerPartyController.remove_from_party(slot.combatant)

func exit() -> void:
	new_character_button.text = _old_text_new_character_button
	remove_character_button.show()
	new_character_button.pressed.disconnect( _on_new_character_button_pressed )
	for slot in active_party_container.get_children():
		if slot is PartyMemberSlot:
			slot.gui_input.disconnect(_on_party_member_slot_clicked)

func check_for_handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		manage_party_buttons_container.hide()
		my_state_machine.change_to_state("NGMSWaiting")
		return

func _on_new_character_button_pressed() -> void:
	my_state_machine.change_to_state("NGMSManageParty")
