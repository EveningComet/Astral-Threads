## Exists to limit the equipment a character can use.
class_name StatRequirement extends Resource

## The attribute being checked.
@export var attribute: StatHelper.StatTypes

## The needed value.
@export var requirement: int = 0
