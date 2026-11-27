extends Node

const BATTLE_SCENE: PackedScene = preload("res://Battle layer/battle_controller.tscn")

@onready var world = $Floor1Casino
@onready var battle_layer = $BattleLayer
@onready var is_final_boss = $is_final_boss

var battle = null
var current_boss = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	world.process_mode = Node.PROCESS_MODE_PAUSABLE

	for boss in get_tree().get_nodes_in_group("boss"):
		boss.battle_requested.connect(start_battle)
		
	for fodder_enemy in get_tree().get_nodes_in_group("fodder_enemy"):
		fodder_enemy.battle_requested.connect(start_battle)
func start_battle(boss) -> void:
	if battle != null:
		return
	current_boss = boss
	world.process_mode = Node.PROCESS_MODE_DISABLED
	battle = BATTLE_SCENE.instantiate()
	battle.dealer = boss.get("dealer") #fodder doesnt have one so this is just null for them
	battle.boss_max_hp = boss.max_hp #have to pass in enemy stats
	battle.boss_damage = boss.damage
	battle.boss_portrait = boss.portrait
	battle_layer.add_child(battle)
	battle.finished.connect(_on_battle_finished)

func _on_battle_finished(won: bool) -> void:
	var enemy = current_boss
	battle.queue_free()
	battle = null
	world.process_mode = Node.PROCESS_MODE_PAUSABLE
	current_boss = null
	if enemy.get("is_final_boss") == true:
		if won:
			get_tree().change_scene_to_file("res://win screen/win_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://game over screen/game_over_screen.tscn")
		return
	if won:
		enemy.on_defeated()
	else:
		enemy.on_lost()
		RunState.reset_run()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		RunState.earn_money(100)   # TEMP: testing only
