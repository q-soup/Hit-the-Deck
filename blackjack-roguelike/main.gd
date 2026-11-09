extends Node

const BATTLE_SCENE: PackedScene = preload("res://Battle layer/battle_controller.tscn")

@onready var world = $Floor1Casino
@onready var battle_layer = $BattleLayer

var battle = null
var current_boss = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	world.process_mode = Node.PROCESS_MODE_PAUSABLE

	for boss in get_tree().get_nodes_in_group("boss"):
		boss.battle_requested.connect(start_battle)

func start_battle(boss) -> void:
	if battle != null:
		return
	current_boss = boss
	get_tree().paused = true
	battle = BATTLE_SCENE.instantiate()
	battle_layer.add_child(battle)
	battle.finished.connect(_on_battle_finished)

func _on_battle_finished(won: bool) -> void:
	battle.queue_free()
	battle = null
	get_tree().paused = false

	if won:
		current_boss.on_defeated()
	else:
		current_boss.on_lost()
	current_boss = null
