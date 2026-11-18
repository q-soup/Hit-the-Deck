extends CanvasLayer

const CARD_SCENE: PackedScene = preload("res://Battle layer/cards.tscn")

@onready var dealer_hand: HBoxContainer = $Root/DealerArea/DealerHand
@onready var player_hand: HBoxContainer = $Root/PlayerArea/PlayerHand
@onready var hit_button: Button = $Root/Buttons/HitButton
@onready var stand_button: Button = $Root/Buttons/StandButton
@onready var next_round_button: Button = $Root/NextRoundButton
@onready var portrait: AnimatedSprite2D = $Root/BossPanel/Portrait
@onready var boss_name: Label = $Root/BossPanel/Name
@onready var boss_bar: TextureProgressBar = $Root/BossPanel/HPBar
@onready var boss_hp_text: Label = $Root/BossPanel/HPText
@onready var boss_dmg: Label = $Root/BossPanel/Dmg
@onready var player_bar: TextureProgressBar = $Root/PlayerPanel/HPBar
@onready var player_hp_text: Label = $Root/PlayerPanel/HPText
@onready var money_label: Label = $Root/PlayerPanel/Money
@onready var dealer_total: Label = $Root/DealerTotal/Label
@onready var player_total: Label = $Root/PlayerTotal/Label
@onready var banner_label: Label = $Root/Banner/Label
@onready var deck_count: Label = $Root/Deck/Count

const ANIMS = {
	"idle": {"frames": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3], "fps": 6, "loop": true},
	"talk": {"frames": [4, 5, 6, 7, 8, 9], "fps": 8, "loop": true}, #for taunts/dialogue later (in battle and out of it)
	"nod": {"frames": [10, 11, 12, 12, 13, 14, 15, 15, 16, 17, 18, 19], "fps": 7, "loop": false},
	"shake": {"frames": [20, 21, 22, 23, 23, 22, 21, 20, 21, 22, 23, 23, 22, 21, 20], "fps": 9, "loop": false},
}

signal hit_pressed
signal stand_pressed
signal next_round_pressed

func _ready() -> void:
	hit_button.pressed.connect(func(): hit_pressed.emit())
	stand_button.pressed.connect(func(): stand_pressed.emit())
	next_round_button.pressed.connect(func(): next_round_pressed.emit())
	banner_label.text = "YOUR TURN"
	money_label.text = "%d chips" % RunState.money
	next_round_button.hide()
	portrait.animation_finished.connect(func(): portrait.play("idle")) #back to idle after a reaction
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
	banner_label.text = text
	next_round_button.show()

func set_buttons_enabled(enabled: bool) -> void:
	hit_button.disabled = not enabled
	stand_button.disabled = not enabled

func set_boss_info(n: String, max_hp: int, dmg: int) -> void:
	boss_name.text = n
	boss_bar.max_value = max_hp
	boss_bar.value = max_hp
	boss_dmg.text = str(dmg)

func reset_for_new_round() -> void:
	banner_label.text = "YOUR TURN"
	next_round_button.hide()
	set_buttons_enabled(true)
	
func set_hp(player_hp: int, boss_hp: int) -> void:
	player_bar.max_value = RunState.max_hp
	player_hp_text.text = str(player_hp)
	boss_hp_text.text = "%d/%d" % [boss_hp, int(boss_bar.max_value)]
	#slides instead of snapping
	create_tween().tween_property(player_bar, "value", player_hp, 0.3)
	create_tween().tween_property(boss_bar, "value", boss_hp, 0.3)

func set_portrait(sheet: Texture2D) -> void:
	var sf := SpriteFrames.new()
	sf.remove_animation("default")
	for anim in ANIMS:
		sf.add_animation(anim)
		sf.set_animation_speed(anim, ANIMS[anim].fps)
		sf.set_animation_loop(anim, ANIMS[anim].loop)
		for i in ANIMS[anim].frames:
			var atlas := AtlasTexture.new()
			atlas.atlas = sheet
			atlas.region = Rect2((i % 10) * 64, floori(i / 10.0) * 64, 64, 64) #column, row on the sheet
			sf.add_frame(anim, atlas)
	portrait.sprite_frames = sf
	portrait.play("idle")

func set_totals(dealer: int, player: int) -> void:
	dealer_total.text = str(dealer)
	player_total.text = str(player)

func set_deck_count(n: int) -> void:
	deck_count.text = "%d left" % n

func react(result: String) -> void:
	if result == "win": 
		portrait.play("shake")
	elif result == "lose":
		portrait.play("nod")
