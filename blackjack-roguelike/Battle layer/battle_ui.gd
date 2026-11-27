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
@onready var player_portrait: AnimatedSprite2D = $Root/PlayerPanel/Portrait
@onready var dealer_items_box: VBoxContainer = $Root/DealerItems

const PLAYER_SHEET = preload("res://art/portraits/player.png")

const ANIMS = {
	"idle": {"frames": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3], "fps": 6, "loop": true},
	"talk": {"frames": [4, 5, 6, 7, 8, 9], "fps": 8, "loop": true}, #for taunts/dialogue later (in battle and out of it)
	"nod": {"frames": [10, 11, 12, 12, 13, 14, 15, 15, 16, 17, 18, 19], "fps": 7, "loop": false},
	"shake": {"frames": [20, 21, 22, 23, 23, 22, 21, 20, 21, 22, 23, 23, 22, 21, 20], "fps": 9, "loop": false},
}

const CARD_W := 96
const GAP := 4 #space between cards when theres room
@onready var e_hint: NinePatchRect = $Root/EHint
@onready var deck: TextureRect = $Root/Deck

const MARGIN := 6 #little buffer so cards dont touch stuff

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
	player_portrait.sprite_frames = build_frames(PLAYER_SHEET)
	player_portrait.play("idle")
	player_portrait.animation_finished.connect(func(): player_portrait.play("idle"))

func _input(event: InputEvent) -> void:
	if get_tree().paused or not visible:
		return

	if event.is_action_pressed("hit") and not hit_button.disabled:
		hit_pressed.emit()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("stand") and not stand_button.disabled:
		stand_pressed.emit()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("continue") and next_round_button.visible:
		next_round_pressed.emit()
		get_viewport().set_input_as_handled()


func add_card(to_dealer: bool, text: String, face_down := false) -> void:
	var card = CARD_SCENE.instantiate()
	(dealer_hand if to_dealer else player_hand).add_child(card)
	card.set_card(text, face_down)
	fit_hand(dealer_hand, deck.get_global_rect().end.x, boss_bar.get_global_rect().position.x)
	fit_hand(player_hand, player_bar.get_global_rect().end.x, e_hint.get_global_rect().position.x)

func clear_hands() -> void:
	for c in dealer_hand.get_children():
		dealer_hand.remove_child(c) #queue_free waits a frame so old cards were still counting
		c.queue_free()
	for c in player_hand.get_children():
		player_hand.remove_child(c)
		c.queue_free()

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

func build_frames(sheet: Texture2D) -> SpriteFrames:
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
	return sf

func set_portrait(sheet: Texture2D) -> void:
	portrait.sprite_frames = build_frames(sheet)
	portrait.flip_h = true #boss faces the table
	portrait.play("idle")

func set_totals(dealer: int, player: int) -> void:
	dealer_total.text = str(dealer)
	player_total.text = str(player)

func set_deck_count(n: int) -> void:
	deck_count.text = "%d left" % n

func react(result: String) -> void:
	if result == "win":
		portrait.play("shake")
		player_portrait.play("nod") #happy bc i won
	elif result == "lose":
		portrait.play("nod")
		player_portrait.play("shake")

func fit_hand(hand: HBoxContainer, left_limit: float, right_limit: float) -> void:
	var n := hand.get_child_count()
	var center : float = hand.get_parent().get_global_rect().get_center().x #hands grow out from the middle
	var max_w := 2.0 * minf(center - left_limit, right_limit - center) - 2 * MARGIN #closer side decides
	var sep := GAP
	if n > 1 and n * CARD_W + (n - 1) * GAP > max_w:
		sep = floori((max_w - n * CARD_W) / (n - 1)) #only overlaps once theyd actually hit something
	hand.add_theme_constant_override("separation", sep)

func set_dealer_items(ids: Array) -> void:
	for c in dealer_items_box.get_children():
		c.queue_free()
	var title := Label.new()
	title.text = "Dealer's items"
	dealer_items_box.add_child(title)
	if ids.is_empty():
		var none := Label.new()
		none.text = "None"
		dealer_items_box.add_child(none)
		return
	for id in ids:
		var item: Dictionary = UpgradeDB.ITEMS[id]
		var row := Label.new()
		row.text = "[%s] %s: %s" % [UpgradeDB.QUALITY_NAME[item.quality], item.name, item.desc]
		dealer_items_box.add_child(row)
		
