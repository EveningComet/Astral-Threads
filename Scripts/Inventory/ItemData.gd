## Stores information for an item.
class_name ItemData extends Resource

@export_category("Base Item Info")
@export var           localization_name:        String = "New Item"
@export_multiline var localization_description: String = "An item."
@export var item_type: ItemTypes.ItemTypes = ItemTypes.ItemTypes.Consumable
@export var image: Texture
@export var max_stack_size: int = 1
@export var base_cost: int = 10
