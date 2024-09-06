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
@export var base_duration_in_turns: int = 3

@export var on_apply_effects:  Array[OnApplySED]  = []
@export var on_tick_effects:   Array[OnTickSED]   = []
@export var on_expire_effects: Array[OnExpireSED] = []

func trigger_on_apply(combatant: Combatant) -> void:
	for effect in on_apply_effects:
		effect.trigger(combatant)

func trigger_on_tick(combatant: Combatant) -> void:
	pass

func trigger_on_expire(combatant: Combatant) -> void:
	for effect in on_expire_effects:
		effect.trigger(combatant)
