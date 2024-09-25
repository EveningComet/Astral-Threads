## Responsible for resolving situations when the player interacts with an NPC.
extends Node

func _ready() -> void:
	Eventbus.begin_conversation.connect( _on_conversation_started )

## Called when the player interacts with an NPC.
func _on_conversation_started(npc_data) -> void:
	# TODO: Prevent getting into combat when talking.
	# Prevent movement and all that jazz
	Globals.is_movement_disabled    = true
	Globals.is_interaction_disabled = true
	Dialogic.timeline_ended.connect( _on_dialogue_finished )
	
	# Begin the conversation
	Dialogic.start(npc_data.dialogue_timeline)

## Called when the player finishes a dialogic timeline sequence.
func _on_dialogue_finished() -> void:
	Dialogic.timeline_ended.disconnect( _on_dialogue_finished )
	
	# Wait a tiny bit to prevent jumping/movement
	# TODO: Wait for a physics frame instead?
	await get_tree().create_timer(0.1, false, true).timeout
	Globals.is_movement_disabled    = false
	Globals.is_interaction_disabled = false
