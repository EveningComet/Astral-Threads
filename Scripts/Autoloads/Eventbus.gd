## A class responsible for passing around needed data.
extends Node

## Fired when a character has run out of health.
signal hp_depleted(combatant: Combatant)

## Fired when the player adds/removes characters to ther party.
signal party_composition_changed(party: Array[PlayerCombatant])
