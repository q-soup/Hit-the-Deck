extends Control

signal closed

@export var shop_kind := "passive"    # set to "drink" on the bartender scene

var reroll_cost := 2
var current_items: Array[String] = []
var sold: Array[bool] = []

@onready var item_buttons: Array = $GridContainer.get_children()
@onready var reroll_button: Button = $RerollButton
@onready var money_label: Label = $MoneyLabel
@onready var close_button: Button = $CloseButton


func _ready() -> void:
	RunState.earn_money(100)
	for i in item_buttons.size():
		item_buttons[i].pressed.connect(_on_item_pressed.bind(i))
	reroll_button.pressed.connect(_on_reroll_pressed)
	close_button.pressed.connect(func(): closed.emit())

	RunState.money_changed.connect(_on_money_changed)
	roll_items()
	_on_money_changed(RunState.money)


func roll_items() -> void:
	current_items = UpgradeDB.roll_items(shop_kind, item_buttons.size())
	sold.clear()
	sold.resize(item_buttons.size())
	sold.fill(false)
	refresh_buttons()


func refresh_buttons() -> void:
	if current_items.is_empty():
		return
	for i in item_buttons.size():
		var btn: Button = item_buttons[i]
		if i >= current_items.size():
			btn.visible = false
			continue
		var id: String = current_items[i]
		var item: Dictionary = UpgradeDB.ITEMS[id]
		var price : int = UpgradeDB.price_of(id)
		btn.tooltip_text = item.desc
		if sold[i]:
			btn.text = "SOLD"
			btn.disabled = true
		else:
			btn.text = "%s\n%s\n$%d" % [item.name, UpgradeDB.QUALITY_NAME[item.quality], price]
			btn.disabled = not RunState.can_afford(price) or not RunState.can_add(id)
	reroll_button.text = "Reroll ($%d)" % reroll_cost
	reroll_button.disabled = not RunState.can_afford(reroll_cost)


func _on_item_pressed(index: int) -> void:
	var id: String = current_items[index]
	if sold[index] or not RunState.can_add(id):
		return
	if not RunState.spend_money(UpgradeDB.price_of(id)):
		return
	RunState.add_item(id)
	sold[index] = true
	refresh_buttons()


func _on_reroll_pressed() -> void:
	if RunState.spend_money(reroll_cost):
		roll_items()


func _on_money_changed(amount: int) -> void:
	money_label.text = "$%d" % amount
	refresh_buttons()
