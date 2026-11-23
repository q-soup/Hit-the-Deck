extends Node

signal hp_changed(hp, max_hp)
# Notifies other parts of the game when the player's money changes.
signal money_changed(money)
signal pause_toggled(is_paused: bool)
signal inventory_changed

const START_HP = 100
enum State {PLAYING, PAUSED, GAME_OVER}
var inventory: Array[String] = []
var stats: Dictionary = {}
var current_state: State = State.PLAYING
var current_floor := 1

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_recalc()
	
func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		if current_state == State.PLAYING:
			set_paused(true)
		elif current_state == State.PAUSED:
			set_paused(false)
		get_viewport().set_input_as_handled()
			
func set_paused(paused: bool):
	if get_tree().current_scene.name != "Main": return #only pause during the actual game
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
	inventory.clear()
	_recalc()
	deck.clear()
	beaten_bosses.clear()
	current_floor = 1
	flags.clear()
	hp_changed.emit(hp, max_hp)
	money_changed.emit(money)


func take_damage(amount):
	hp = max(hp - amount, 0)
	hp_changed.emit(hp, total_max_hp())

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
	
	
func _recalc() -> void:
	stats = UpgradeDB.calc_stats(inventory)
	inventory_changed.emit()

func add_item(id: String) -> void:
	inventory.append(id)
	_recalc()

func drink_count() -> int:
	var n := 0
	for id in inventory:
		if UpgradeDB.ITEMS[id].kind == "drink":
			n += 1
	return n

func drunk_points() -> int:
	var total := 0
	for id in inventory:
		total += UpgradeDB.ITEMS[id].get("drunk_points", 0)
	return total

func can_add(id: String) -> bool:
	if UpgradeDB.ITEMS[id].kind == "drink":
		return drink_count() < stats.drink_slots
	return true

func drunk_level() -> String:      # placeholder thresholds, tune later
	var p := drunk_points()
	if p >= 10: return "Wasted"
	if p >= 7: return "Drunk"
	if p >= 5: return "Buzzed"
	if p >= 2: return "Tipsy"
	return "Sober"
	
func total_max_hp() -> int:
	return max_hp + stats.max_hp #base hp plus whatever items add
