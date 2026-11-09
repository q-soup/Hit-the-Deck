extends Node

const BATTLE_UI_SCENE: PackedScene = preload("res://Battle layer/battle_ui.tscn")

@onready var game = $Blackjack
var battle_ui

signal finished(won)

@export var boss_max_hp = 50
@export var player_damage = 10
@export var boss_damage = 10
var boss_hp: int

func _ready() -> void:
	start_battle()

func start_battle() -> void:
	battle_ui = BATTLE_UI_SCENE.instantiate()
	add_child(battle_ui)

	battle_ui.hit_pressed.connect(_on_hit_pressed)
	battle_ui.stand_pressed.connect(_on_stand_pressed)
	battle_ui.next_round_pressed.connect(_on_next_round_pressed)
	game.round_ended.connect(_on_round_ended)
	
	boss_hp = boss_max_hp
	
	game.start_round()
	refresh_ui()

func _on_hit_pressed() -> void:
	game.hit()
	refresh_ui()

func _on_stand_pressed() -> void:
	game.stand()
	refresh_ui()
	
func _on_next_round_pressed() -> void:
	if boss_hp == 0 or RunState.hp == 0:
		finished.emit(boss_hp == 0)
		return
	battle_ui.reset_for_new_round()
	game.start_round()
	refresh_ui()
	battle_ui.set_hp(RunState.hp, boss_hp)

func _on_round_ended(result: String, message: String) -> void:
	if result == "win":
		boss_hp = max(boss_hp - player_damage, 0)
	elif result == "lose":
		RunState.take_damage(boss_damage)
		
	if boss_hp == 0:
		message = "Boss defeated!"
	elif $Runstate.hp == 0:
		message = "You lost..."
		
	battle_ui.show_result(message)
	battle_ui.set_buttons_enabled(false)
	refresh_ui()
	battle_ui.set_hp(RunState.hp, boss_hp)

# Redraws both hands from the blackjack script's data
func refresh_ui() -> void:
	battle_ui.clear_hands()
	for card in game.player_hand:
		battle_ui.add_card(false, pretty(card))
	for i in game.dealer_hand.size():
		# Dealer's second card stays face down until the round is over
		var hidden: bool = (i == 1 and not game.round_over)
		battle_ui.add_card(true, pretty(game.dealer_hand[i]), hidden)

# Turns "KH" into "K♥"
func pretty(card: String) -> String:
	var rank: String = card.substr(0, card.length() - 1)
	var suit: String = card.substr(card.length() - 1)
	var symbols := {"H": "♥", "D": "♦", "C": "♣", "S": "♠"}
	return rank + symbols[suit]
