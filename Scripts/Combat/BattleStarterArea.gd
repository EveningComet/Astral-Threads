## A component meant to be placed on things such as roaming enemies or
## special encounters. When the player connects with this, it will start a battle.
class_name BattleStarterArea extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect( on_body_entered )

func on_body_entered(body) -> void:
	# TODO: More elegant way of checking
	if body.name == "Player":
		var epd: EnemyPartyData = get_parent().get_node("EnemyPartyData")
		Eventbus.start_battle.emit(epd)
