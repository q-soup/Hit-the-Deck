extends CanvasLayer

const CARD_SCENE: PackedScene = preload("res://Battle layer/card_place_holder.tscn")

@onready var dealer_hand: HBoxContainer = $Root/DealerArea/DealerHand
@onready var player_hand: HBoxContainer = $Root/PlayerArea/PlayerHand
@onready var hit_button: Button = $Root/Buttons/HitButton
@onready var stand_button: Button = $Root/Buttons/StandButton
@onready var result_label: Label = $Root/ResultLabel
@onready var next_round_button: Button = $Root/NextRoundButton
@onready var hp_label: Label = $Root/HPLabel

signal hit_pressed
signal stand_pressed
signal next_round_pressed

func _ready() -> void:
	hit_button.pressed.connect(func(): hit_pressed.emit())
	stand_button.pressed.connect(func(): stand_pressed.emit())
	next_round_button.pressed.connect(func(): next_round_pressed.emit())
	result_label.hide()
	next_round_button.hide()
	#add_card(true, "K♥")	
	#add_card(false, "A♠")
	#print("dealer cards: ", dealer_hand.get_child_count(), " player cards: ", player_hand.get_child_count())

func add_card(to_dealer: bool, text: String, face_down := false) -> void:
	var card = CARD_SCENE.instantiate()
	(dealer_hand if to_dealer else player_hand).add_child(card)
	card.set_card(text, face_down)

func clear_hands() -> void:
	for c in dealer_hand.get_children(): c.queue_free()
	for c in player_hand.get_children(): c.queue_free()

func show_result(text: String) -> void:
	result_label.text = text
	result_label.show()
	next_round_button.show()

func set_buttons_enabled(enabled: bool) -> void:
	hit_button.disabled = not enabled
	stand_button.disabled = not enabled

func reset_for_new_round() -> void:
	result_label.hide()
	next_round_button.hide()
	set_buttons_enabled(true)
	
func set_hp(player_hp: int, boss_hp: int):
	hp_label.text = "You: %d    Boss: %d" % [player_hp, boss_hp]
