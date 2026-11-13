extends Node

signal hp_changed(hp, max_hp)
# Notifies other parts of the game when the player's money changes.
signal money_changed(money)
signal pause_toggled(is_paused: bool)

const START_HP = 100
enum State {PLAYING, PAUSED, GAME_OVER}
var current_state: State = State.PLAYING

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		if current_state == State.PLAYING:
			set_paused(true)
		elif current_state == State.PAUSED:
			set_paused(false)
			
func set_paused(paused: bool):
	current_state = State.PAUSED if paused else State.PLAYING
	get_tree().paused = paused
	pause_toggled.emit(paused)

var max_hp = START_HP
var hp = START_HP
var money: int = 0
var deck: Array = [] #will change once someone finishes the card resource
var beaten_bosses: Array[String] = []
var flags: Array[String] = []

func reset_run():
	max_hp = START_HP
	hp = max_hp
	money = 0
	deck.clear()
	beaten_bosses.clear()
	flags.clear()
	hp_changed.emit(hp, max_hp)
	money_changed.emit(money)


func take_damage(amount):
	hp = max(hp - amount, 0)
	hp_changed.emit(hp, max_hp)

func has_flag(flag): #pass in a string
	return flags.has(flag)
	
# Adds money to the player's balance after winning a fight.
func earn_money(amount: int) -> void:
	if amount <= 0:
		return

	money += amount
	money_changed.emit(money)


# Checks whether the player has enough money to purchase an item.
func can_afford(cost: int) -> bool:
	return cost >= 0 and money >= cost


# Attempts to purchase an item by deducting its cost.
# Returns true if the player has enough money.
# Returns false if the player cannot afford the item.
func spend_money(cost: int) -> bool:
	if cost < 0 or not can_afford(cost):
		return false

	money -= cost
	money_changed.emit(money)
	return true
