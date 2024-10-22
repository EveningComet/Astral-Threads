## A thing that exists on a character and does something to them.
class_name StatusEffect extends Resource

@export_category("Base Info")
@export var localization_name:                  String = "New Status Effect"
@export_multiline var localization_description: String = "New description."
@export var display_icon: Texture2D

## Used as a quick and dirty way to check if a character has negative status effects present.
@export var is_negative: bool = false

@export_category("Definitions")

## By default, how long this status effect applies in turns.
@export var duration_in_turns: int = 3

@export var on_apply_effects:  Array[OnApplySED]  = []
@export var on_tick_effects:   Array[OnTickSED]   = []
@export var on_expire_effects: Array[OnExpireSED] = []

# Instanced variables
## How long has this status effect been active?
var lifetime_in_turns: int = 0

## The character that originally applied this status effect.
var activator: Combatant

func trigger_on_apply(target: Combatant) -> void:
	for effect in on_apply_effects:
		effect.trigger(target, lifetime_in_turns)

func trigger_on_tick(target: Combatant) -> void:
	for effect in on_tick_effects:
		effect.trigger(target, lifetime_in_turns)

func trigger_on_expire(target: Combatant) -> void:
	for effect in on_expire_effects:
		effect.trigger(target, lifetime_in_turns)
