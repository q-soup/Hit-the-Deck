extends Node2D

signal boss_hp_changed(hp, max_hp)
signal fight_ended(player_won)

@export var boss_max_hp: int = 100
@export var base_damage: int = 10

var boss_hp: int
var fight_over: bool = false


func _ready() -> void:
	boss_hp = boss_max_hp
	boss_hp_changed.emit(boss_hp, boss_max_hp)
	# Temporary tests
	RunState.reset_run()

	resolve_hand(true, 2.0)
	print("Boss HP: ", boss_hp) # Expected: 80

	resolve_hand(false, 1.5)
	print("Player HP: ", RunState.hp) # Expected: 85

	resolve_hand(true, 10.0)
	print("Boss HP: ", boss_hp) # Expected: 0
	print("Fight over: ", fight_over) # Expected: true

	resolve_hand(false, 1.0)
	print("Player HP after fight: ", RunState.hp) # Expected: still 85

# Call once per hand. For a tie, skip this function.
func resolve_hand(player_won: bool, modifier: float = 1.0) -> void:
	if fight_over:
		return

	var damage: int = maxi(roundi(base_damage * modifier), 0)

	if player_won:
		boss_hp = maxi(boss_hp - damage, 0)
		boss_hp_changed.emit(boss_hp, boss_max_hp)
	else:
		RunState.take_damage(damage)

	check_fight_end()


func check_fight_end() -> void:
	if boss_hp <= 0:
		fight_over = true
		fight_ended.emit(true)
	elif RunState.hp <= 0:
		fight_over = true
		fight_ended.emit(false)
