## Displays a visual represenation of an enemy in battle.
class_name EnemyBattleSprite extends PanelContainer

@export var portrait: TextureRect

## The character currently being represented. Used to easily get access to targets.
var combatant: Combatant

func set_combatant(new_com: Combatant, _portrait: Texture2D) -> void:
	combatant = new_com
	portrait.set_texture(_portrait)

func on_stat_changed(com: Combatant) -> void:
	pass
