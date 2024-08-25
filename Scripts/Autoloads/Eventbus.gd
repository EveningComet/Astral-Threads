## A class responsible for passing around needed data.
extends Node

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
