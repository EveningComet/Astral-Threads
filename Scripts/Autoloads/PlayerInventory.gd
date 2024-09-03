## Stores the player's inventory for easy access.
extends Node

## The player's inventory.
var inventory: Inventory = Inventory.new()

func does_player_have_enough_money_for_item(item_data: ItemData) -> bool:
	return inventory.money >= item_data.base_cost
