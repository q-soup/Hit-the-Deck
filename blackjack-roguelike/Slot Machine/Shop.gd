extends Control

signal closed

# Everything the shop can sell. Add more here anytime.
var all_items: Array = [
	{"name": "Lucky Chip", "price": 5},
	{"name": "Extra Card", "price": 8},
	{"name": "Peek", "price": 6},
	{"name": "Ace Boost", "price": 10},
	{"name": "Insurance", "price": 4},
	{"name": "Shield", "price": 7},
]

var reroll_cost := 2
var current_items: Array = []
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

	RunState.money_changed.connect(_on_money_changed)
	_on_money_changed(RunState.money)

	roll_items()
	
	close_button.pressed.connect(func(): closed.emit())

func roll_items() -> void:
	current_items.clear()
	sold.clear()
	for i in item_buttons.size():
		current_items.append(all_items.pick_random())
		sold.append(false)
	refresh_buttons()


func refresh_buttons() -> void:
	if current_items.is_empty():
		return
	for i in item_buttons.size():
		var item = current_items[i]
		if sold[i]:
			item_buttons[i].text = "SOLD"
			item_buttons[i].disabled = true
		else:
			item_buttons[i].text = "%s\n$%d" % [item.name, item.price]
			item_buttons[i].disabled = not RunState.can_afford(item.price)
	reroll_button.text = "Reroll ($%d)" % reroll_cost
	reroll_button.disabled = not RunState.can_afford(reroll_cost)


func _on_item_pressed(index: int) -> void:
	var item = current_items[index]
	if sold[index] or not RunState.spend_money(item.price):
		return
	RunState.add_upgrade(item.name)
	sold[index] = true
	refresh_buttons()


func _on_reroll_pressed() -> void:
	if not RunState.spend_money(reroll_cost):
		return
	roll_items()


func _on_money_changed(new_amount: int) -> void:
	money_label.text = "$%d" % new_amount
	refresh_buttons()
