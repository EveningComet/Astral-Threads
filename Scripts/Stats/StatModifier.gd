## Stores data for something that modifies a stat.
class_name StatModifier extends Resource

## What stat does this modifier change?
@export var stat_changing: StatHelper.StatTypes

## Which type of modifier does this give?
@export var stat_modifier_type: StatModifierTypes.StatModifierTypes

## The modifier's value
@export var value: float = 0.0

## How much priority does this modifier have?
@export var sort_order: int = 0

## Get the value of this modifier
func get_value() -> float:
	return value

## What type of modifier is this?
func get_modifier_type():
	return stat_modifier_type

## Get the sorting order.
func get_sort_order() -> int:
	return sort_order
