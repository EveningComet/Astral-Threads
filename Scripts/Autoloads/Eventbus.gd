## A class responsible for passing around needed data.
extends Node

## Fired when the player wants to do something with their inventory or party.
signal toggle_dashboard(exterior_inv: Inventory)

signal toggle_skill_menu(turn_on: bool)

## Fired when the player interacts with an NPC.
signal begin_conversation(target)

## Enables/Disables the mouse.
signal toggle_mouse(status: bool)

## Fired when a character has run out of health.
signal hp_depleted(combatant: Combatant)

## Fired when the player adds/removes characters to ther party.
signal party_composition_changed(party: Array[PlayerCombatant])

## Fired when the player touches an enemy.
signal start_battle(enemy_party: EnemyPartyData)

signal player_turn_started()

## Combat event that gets fired when the player or the enemy finishes their turn.
signal side_finished_turn(stored_actions: Array[StoredAction])

signal battle_ended()

## Taking the passed object, display the needed information to the player.
signal tooltip_needed(object: Control)

## Used to remove any and all tooltips.
signal tooltip_unneeded()
