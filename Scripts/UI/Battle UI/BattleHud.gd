## Manages UI elements for battles.
class_name BattleHud extends CanvasLayer

@export var enemy_container: Container

@export var enemy_battle_sprite_prefab: PackedScene

func _ready() -> void:
	Eventbus.battle_ended.connect( on_battle_ended )
	clear_displayed_enemies()
	hide()

func on_battle_start(active_enemies: Array[EnemyCombatant]) -> void:
	# Create sprites/portraits for the enemies
	for e in active_enemies:
		var battle_sprite: EnemyBattleSprite = enemy_battle_sprite_prefab.instantiate()
		battle_sprite.set_combatant(e)
		enemy_container.add_child(battle_sprite)
	
	# Everything is done, time to display and get ready
	show()

func on_battle_ended() -> void:
	clear_displayed_enemies()
	hide()

func clear_displayed_enemies() -> void:
	for c in enemy_container.get_children():
		c.queue_free()
