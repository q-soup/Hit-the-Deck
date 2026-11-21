extends Node

signal finished(won: bool)

const BATTLE_UI_SCENE: PackedScene = preload("res://Battle layer/battle_ui.tscn")

@onready var game = $Blackjack
var battle_ui
var dealer: DealerData
@export var boss_max_hp = 50
@export var player_damage = 10
@export var boss_damage = 10
@export var boss_portrait: Texture2D
@export var boss_name := "Boss"
var boss_hp: int

func _ready() -> void:
	start_battle()

func start_battle() -> void:
	battle_ui = BATTLE_UI_SCENE.instantiate()
	add_child(battle_ui)
	if dealer != null:
		boss_name = "%s Lv. %d" % [boss_name, dealer.level]
		boss_max_hp = dealer.max_hp
		boss_damage = dealer.damage
		battle_ui.set_dealer_items(dealer.items)
	battle_ui.hit_pressed.connect(_on_hit_pressed)
	battle_ui.stand_pressed.connect(_on_stand_pressed)
	battle_ui.next_round_pressed.connect(_on_next_round_pressed)
	game.round_ended.connect(_on_round_ended)
	battle_ui.set_portrait(boss_portrait)
	battle_ui.set_boss_info(boss_name, boss_max_hp, boss_damage)
	
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

func _on_round_ended(result: String, message: String) -> void:
	var s: Dictionary = RunState.stats
	if result == "win":
		var dmg := roundi((player_damage + s.damage_flat) * s.damage_mult)
		if dealer != null:
			dmg = maxi(1, dmg - dealer.stats.armor)
			var reflected := ceili(dmg * dealer.stats.thorns)
			if reflected > 0:
				RunState.take_damage(reflected)
		boss_hp = max(boss_hp - dmg, 0)
		if s.heal_on_win > 0:
			RunState.hp = mini(RunState.total_max_hp(), RunState.hp + s.heal_on_win)
			RunState.hp_changed.emit(RunState.hp, RunState.total_max_hp())
	elif result == "lose":
		var taken := maxi(1, boss_damage - s.armor)
		RunState.take_damage(taken)
		if s.thorns > 0.0:
			boss_hp = max(boss_hp - ceili(taken * s.thorns), 0)
		if dealer != null and boss_hp > 0:
			boss_hp = mini(boss_max_hp, boss_hp + dealer.stats.heal_on_win)

	if boss_hp == 0:
		message = "Boss defeated!"
	elif RunState.hp == 0:
		message = "You lost..."

	battle_ui.react(result)
	battle_ui.show_result(message)
	battle_ui.set_buttons_enabled(false)
	refresh_ui()

# Redraws both hands from the blackjack script's data
func refresh_ui() -> void:
	battle_ui.clear_hands()
	for card in game.player_hand:
		battle_ui.add_card(false, card)
	for i in game.dealer_hand.size():
		# Dealer's second card stays face down until the round is over
		var hidden: bool = (i == 1 and not game.round_over)
		battle_ui.add_card(true, game.dealer_hand[i], hidden)
	battle_ui.set_hp(RunState.hp, boss_hp)
	var dealer_shown: Array[String] = [game.dealer_hand[0]] #only count the face up card till the round ends
	if game.round_over:
		dealer_shown = game.dealer_hand
	battle_ui.set_totals(game.hand_value(dealer_shown), game.hand_value(game.player_hand))
	battle_ui.set_deck_count(game.deck.size())

# unused - Turns "KH" into "K♥" 
"""func pretty(card: String) -> String:
	var rank: String = card.substr(0, card.length() - 1)
	var suit: String = card.substr(card.length() - 1)
	var symbols := {"H": "♥", "D": "♦", "C": "♣", "S": "♠"}
	return rank + symbols[suit]"""
