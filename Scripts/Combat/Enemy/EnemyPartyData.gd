## A component meant to be attached to enemies to store what characters a player
## will fight at a given time.
class_name EnemyPartyData extends Node

## The current enemies stored in this party.
@export var party: Array[EnemyData] = []
