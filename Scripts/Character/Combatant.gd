## Component that represents a character that can take damage and die in the
## game world.
class_name Combatant extends Node

## Event that gets fired whenever a stat changed.
signal stat_changed(com: Combatant)

## The component that stores all of a characters stats for tidyness.
@export var stats: Stats = Stats.new(self)
