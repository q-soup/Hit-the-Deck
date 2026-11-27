class_name PowerUps
extends RefCounted

signal changed

const RARITY_NAME := {
	1: "Common",
	2: "Rare",
	3: "Legendary"
}

const DEFS := {

	# ========================
	# LEGENDARY
	# ========================

		#--KRAKENS FURY--
			"krakens_fury": {
				"name": "Krakens Fury",
				"category": "damage_mult",
				"rarity": 3,
				"effect": {"wins": 3, "mult": 3.0},
				"desc": "Your next 3 wins deal triple damage."
			},
		#--BLACKBEARDS TREASURE--
			"blackbeards_treasure": {
				"name": "Blackbeards Treasure",
				"category": "damage_mult",
				"rarity": 3,
				"effect": {"first_mult": 2.0, "rest_mult": 1.25},
				"desc": "Lasts the whole table. First win deals 2x damage, the rest deal 1.25x."
			},
		#KRAENS TOOTH--
			"kraken_tooth": {
				"name": "Kraken Tooth",
				"category": "dealer",
				"rarity": 3,
				"effect": {"damage_flat": 10, "thorns": 0.15},
				"desc": "Hits 10 harder, reflects 15%."
			},

	# ========================
	# RARE
	# ========================

			#--BROADSIDE BAR--
				"broadside_bar": {
					"name": "Broadside Bar",
					"category": "damage_mult",
					"rarity": 2,
					"effect": {"wins": 1, "mult": 2.0},
					"desc": "Next win deals 2x damage."
				},
			#--FIRE THE CANNON--
				"fire_the_cannon": {
					"name": "Fire the Cannon",
					"category": "damage_mult",
					"rarity": 2,
					"effect": {"wins": 2, "mult": 1.5},
					"desc": "Next 2 wins deal 1.5x damage."
				},
			#--CAPTAINS COAT--
				"captains_coat": {
					"name": "Captain's Coat",
					"category": "dealer",
					"rarity": 2,
					"effect": {"armor": 4, "max_hp": 30},
					"desc": "Takes 4 less damage, +30 max HP."
				},

	# ========================
	# COMMON
	# ========================

			#--SOFT TOUCH--
				"soft_touch": {
					"name": "Soft Touch",
					"category": "passive",
					"rarity": 1,
					"effect": {"dealer_stand": -2},
					"desc": "Dealer must stand on 15."
				},
			#--AIM FOR 24--
				"aim_24": {
					"name": "Aim for 24",
					"category": "passive",
					"rarity": 1,
					"effect": {"target": 3},
					"desc": "Aim for 24 instead of 21."
				},
			#--THORNS--
				"thorns": {
					"name": "Thorns",
					"category": "passive",
					"rarity": 1,
					"effect": {"thorns": 0.03},
					"desc": "Reflect 3% of damage taken."
				},
			#--SHARP CARDS--
				"sharp_cards": {
					"name": "Sharp Cards",
					"category": "passive",
					"rarity": 1,
					"effect": {"damage_flat": 1},
					"desc": "+1 damage."
				},
			#--BRASS KNUCKLES--
				"brass_knuckles": {
					"name": "Brass Knuckles",
					"category": "dealer",
					"rarity": 1,
					"effect": {"damage_flat": 3},
					"desc": "Hits 3 harder."
				},
			#--IRON LIVER--
				"iron_liver": {
					"name": "Iron Liver",
					"category": "dealer",
					"rarity": 1,
					"effect": {"max_hp": 15},
					"desc": "+15 max HP."
				},
			#--PADDED VEST--
				"padded_vest": {
					"name": "Padded Vest",
					"category": "dealer",
					"rarity": 1,
					"effect": {"armor": 2},
					"desc": "Takes 2 less damage."
				},
			#--BARBED CHIPS--
				"barbed_chips": {
					"name": "Barbed Chips",
					"category": "dealer",
					"rarity": 1,
					"effect": {"thorns": 0.10},
					"desc": "Reflects 10% of damage taken."
				},
			#--BAR TAB--
				"bar_tab": {
					"name": "Bar Tab",
					"category": "dealer",
					"rarity": 1,
					"effect": {"heal_on_win": 5},
					"desc": "Heals 5 HP when he wins a hand."
				}
}

var held: Array[String] = []
var active: Array[Dictionary] = []
var table_wins := 0


func add(id: String) -> void:
	assert(DEFS.has(id), "Unknown power up: %s" % id)
	held.append(id)
	changed.emit()


func use(id: String) -> bool:
	if not held.has(id):
		return false

	held.erase(id)

	active.append({
		"id": id,
		"wins_left": DEFS[id].effect.get("wins", -1)
	})

	changed.emit()
	return true


func on_table_start() -> void:
	active.clear()
	table_wins = 0
	changed.emit()


func on_table_end() -> void:
	on_table_start()


func consume_win_multiplier() -> float:
	var mult := 1.0

	for a in active.duplicate():
		var eff: Dictionary = DEFS[a.id].effect

		if eff.has("first_mult"):
			mult *= eff.first_mult if table_wins == 0 else eff.rest_mult
		else:
			mult *= eff.mult
			a.wins_left -= 1

			if a.wins_left <= 0:
				active.erase(a)

	table_wins += 1
	changed.emit()

	return mult


static func get_ids_of_rarity(rarity: int) -> Array[String]:
	var result: Array[String] = []

	for id in DEFS:
		if DEFS[id].rarity == rarity:
			result.append(id)

	return result


static func roll_item(rarity: int) -> String:
	var pool := get_ids_of_rarity(rarity)

	if pool.is_empty():
		return ""

	return pool.pick_random()
