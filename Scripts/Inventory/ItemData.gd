## Stores information for an item.
class_name ItemData extends Resource

@export_category("Base Item Info")
@export var           localization_name:        String = "New Item"
@export_multiline var localization_description: String = "An item."
@export var item_type: ItemTypes.ItemTypes = ItemTypes.ItemTypes.Consumable
@export var image: Texture
@export var max_stack_size: int = 1
@export var base_cost: int = 10

@export_category("Equipment Info")
@export var equip_type: ItemTypes.EquipmentTypes = ItemTypes.EquipmentTypes.None

## If this is a piece of equipment, what stats does this change?
@export var stat_modifiers: Array[StatModifier] = []

## What are the requirements to use this piece of equipment?
@export var attribute_requirements: Array[StatRequirement] = []

@export_category("Weapon Info")
@export var weapon_type: ItemTypes.WeaponTypes = ItemTypes.WeaponTypes.None
