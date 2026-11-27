<<<<<<< Updated upstream
class_name PowerUps
extends RefCounted
"""
	This is a one time use obtainable from the slot machine and runs one instance in RunState
		RunState.power_ups.add("broadside_bar")
		RunState.power_ups.use("broadside_bar")
		
	The 'use' activates a held power up and the battle controller calls on_table_start()
	consume_win_multiplayer() / on_table_end()
		
	The effect keys:
		wins + mult            -> the next 'wins' multiply damage by 'mult'
		first_mult + rest_mult -> lasts the whole table: first win uses the first_mult, 
								  every win after that uses rest_mult
"""

signal changed

=======

class_name PowerUps
extends RefCounted

signal changed

const RARITY_NAME := {
	1: "Common",
	2: "Rare",
	3: "Legendary"
}

>>>>>>> Stashed changes
const DEFS := {
	
	# ========================
	# LEGENDARY
	# ========================
<<<<<<< Updated upstream
	#--KRAKENS FURY--
	"krakens_fury": {
		"name": "Krakens Fury", 
		"catagory": "damage_mult", 
		"rarity": 3,
		"effect": {
			"wins": 3, 
			"mult": 3.0
		}, 
		"desc": "Your next 3 wins deal triple damage."
	},
	#--BLACKBEARDS TREASURE--
	"blackbeards_treasure": {
		"name": "Blackbeards Treasure", 
		"category": "damage_mult", 
=======

	"krakens_fury": {
		"name": "Krakens Fury",
		"category": "damage_mult",
		"rarity": 3,
		"effect": {
			"wins": 3, 
			"mult": 3.0,
		},
		"desc": "Your next 3 wins deal triple damage."
	},

	"blackbeards_treasure": {
		"name": "Blackbeards Treasure",
		"category": "damage_mult",
>>>>>>> Stashed changes
		"rarity": 3,
		"effect": {
			"first_mult": 2.0, 
			"rest_mult": 1.25,
		},
<<<<<<< Updated upstream
		"desc": "Lasts the whole table. First win deals 2x damage, the rest deal 1.25x"
	},
	#--KRAKENS TOOTH--
	"kraken_tooth": {
		"name": "Kraken Tooth", 
		"kind": "dealer", 
		"rarity": 3,
		"effects": {
			"damage_flat": 10, 
			"thorns": 0.15,
		}, 
		"desc": "Hits 10 harder, reflects 15%"
	},
	#--CAPTAINS COST--
	"captains_coat": {
		"name": "Captain's Coat", 
		"kind": "dealer", 
		"rarity": 3,
		"effects": {
			"armor": 4, 
			"max_hp": 30,
		}, 
		"desc": "Takes 4 less damage, +30 max HP"
	},
	# ========================
	# RARE
	# ========================
	#--BROADSIDE BAR--
	"broadside_bar": {
		"name": "Broadside Bar", 
		"category": "damage_mult", 
=======
		"desc": "Lasts the whole table. First win deals 2x damage, the rest deal 1.25x."
	},

	"kraken_tooth": {
		"name": "Kraken Tooth",
		"category": "dealer",
		"rarity": 3,
		"effect": {
			"damage_flat": 10, 
			"thorns": 0.15,
		},
		"desc": "Hits 10 harder, reflects 15%."
	},

	# ========================
	# RARE
	# ========================

	"broadside_bar": {
		"name": "Broadside Bar",
		"category": "damage_mult",
>>>>>>> Stashed changes
		"rarity": 2,
		"effect": {
			"wins": 1, 
			"mult": 2.0,
<<<<<<< Updated upstream
		}, 
		"desc": "Next win deals 2x damage"
	},
	#--FIRE THE CANNON--
	"fire_the_cannon": {
		"name": "Fire the Cannon", 
		"category": "damage_mult", 
=======
		},
		"desc": "Next win deals 2x damage."
	},

	"fire_the_cannon": {
		"name": "Fire the Cannon",
		"category": "damage_mult",
>>>>>>> Stashed changes
		"rarity": 2,
		"effect": {
			"wins": 2, 
			"mult": 1.5,
<<<<<<< Updated upstream
		}, 
		"desc": "Next 2 wins deal 1.5x damage"
	},
	#--SOFT TOUCH--
	"soft_touch": {
		"name": "Soft Touch", 
		"kind": "passive", 
		"rarity": 2,
		"effects": {
			"dealer_stand": -2,
		}, 
		"desc": "Dealer must stand on 15"
	},
	#--BARBED CHIPS--
	"barbed_chips": {
		"name": "Barbed Chips", 
		"kind": "dealer", 
		"rarity": 2,
		"effects": {
			"thorns": 0.10,
		}, 
		"desc": "Reflects 10% of damage taken"
	},
	#--AIM 24--
	"aim_24": {
		"name": "Aim for 24", 
		"kind": "passive", 
		"rarity": 3,
		"effects": {
			"target": 3,
		}, 
		"desc": "Aim for 24 instead of 21"
	},
	# ========================
	# COMMON
	# ========================
	#--THORNS--
	"thorns": {
		"name": "Thorns", 
		"kind": "passive", 
		"rarity": 1,
		"effects": {
			"thorns": 0.03,
		}, 
		"desc": "Reflect 3% of damage taken"
	},
	#--SHARP CARDS--
	"sharp_cards": {
		"name": "Sharp Cards", 
		"kind": "passive", 
		"rarity": 1,
		"effects": {
			"damage_flat": 1,
		}, 
		"desc": "+1 damage"
	},
	#--BRASS KNUCKLES--
	"brass_knuckles": {
		"name": "Brass Knuckles", 
		"kind": "dealer", 
		"rarity": 1,
		"effects": {
			"damage_flat": 3,
		}, 
		"desc": "Hits 3 harder"
	},
	#--IRON LIVER--
	"iron_liver": {
		"name": "Iron Liver", 
		"kind": "dealer", 
		"rarity": 1,
		"effects": {
			"max_hp": 15,
		}, 
		"desc": "+15 max HP"
	},
	#--PADDED VEST--
	"padded_vest": {
		"name": "Padded Vest", 
		"kind": "dealer", 
		"rarity": 1,
		"effects": {
			"armor": 2,
		}, 
		"desc": "Takes 2 less damage"
	},
	#--BAR TAB--
	"bar_tab": {
		"name": "Bar Tab", 
		"kind": "dealer", 
		"rarity": 1,
		"effects": {
			"heal_on_win": 5,
		}, 
		"desc": "Heals 5 HP when he wins a hand"
=======
		},
		"desc": "Next 2 wins deal 1.5x damage."
	},

	"captains_coat": {
		"name": "Captain's Coat",
		"category": "dealer",
		"rarity": 2,
		"effect": {
			"armor": 4, 
			"max_hp": 30,
		},
		"desc": "Takes 4 less damage, +30 max HP."
	},

	# ========================
	# COMMON
	# ========================

	"soft_touch": {
		"name": "Soft Touch",
		"category": "passive",
		"rarity": 1,
		"effect": {
			"dealer_stand": -2,
		},
		"desc": "Dealer must stand on 15."
	},

	"aim_24": {
		"name": "Aim for 24",
		"category": "passive",
		"rarity": 1,
		"effect": {
			"target": 3,
		},
		"desc": "Aim for 24 instead of 21."
	},

	"thorns": {
		"name": "Thorns",
		"category": "passive",
		"rarity": 1,
		"effect": {
			"thorns": 0.03,
		},
		"desc": "Reflect 3% of damage taken."
	},

	"sharp_cards": {
		"name": "Sharp Cards",
		"category": "passive",
		"rarity": 1,
		"effect": {
			"damage_flat": 1,
		},
		"desc": "+1 damage."
	},

	"brass_knuckles": {
		"name": "Brass Knuckles",
		"category": "dealer",
		"rarity": 1,
		"effect": {
			"damage_flat": 3,
		},
		"desc": "Hits 3 harder."
	},

	"iron_liver": {
		"name": "Iron Liver",
		"category": "dealer",
		"rarity": 1,
		"effect": {
			"max_hp": 15,
		},
		"desc": "+15 max HP."
	},

	"padded_vest": {
		"name": "Padded Vest",
		"category": "dealer",
		"rarity": 1,
		"effect": {
			"armor": 2,
		},
		"desc": "Takes 2 less damage."
	},

	"barbed_chips": {
		"name": "Barbed Chips",
		"category": "dealer",
		"rarity": 1,
		"effect": {
			"thorns": 0.10,
		},
		"desc": "Reflects 10% of damage taken."
	},

	"bar_tab": {
		"name": "Bar Tab",
		"category": "dealer",
		"rarity": 1,
		"effect": {
			"heal_on_win": 5,
		},
		"desc": "Heals 5 HP when he wins a hand."
>>>>>>> Stashed changes
	}
}

var held: Array[String] = []
<<<<<<< Updated upstream
var active:Array[Dictionary] = []
var table_wins := 0

=======
var active: Array[Dictionary] = []
var table_wins := 0


>>>>>>> Stashed changes
func add(id: String) -> void:
	assert(DEFS.has(id), "Unknown power up: %s" % id)
	held.append(id)
	changed.emit()
<<<<<<< Updated upstream
	
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

=======


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


>>>>>>> Stashed changes
func on_table_start() -> void:
	active.clear()
	table_wins = 0
	changed.emit()
<<<<<<< Updated upstream
	
func on_table_end() -> void:
	on_table_start()
	
func consume_win_multiplier() -> float:
	var mult := 1.0
	
	for a in active.duplicate():
		var eff: Dictionary = DEFS[a.id].effect
		
=======


func on_table_end() -> void:
	on_table_start()


func consume_win_multiplier() -> float:
	var mult := 1.0

	for a in active.duplicate():
		var eff: Dictionary = DEFS[a.id].effect

>>>>>>> Stashed changes
		if eff.has("first_mult"):
			mult *= eff.first_mult if table_wins == 0 else eff.rest_mult
		else:
			mult *= eff.mult
			a.wins_left -= 1
<<<<<<< Updated upstream
			
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
=======

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


>>>>>>> Stashed changes
static func roll_item(rarity: int) -> String:
	var pool := get_ids_of_rarity(rarity)

	if pool.is_empty():
		return ""

	return pool.pick_random()
<<<<<<< Updated upstream
	
=======
>>>>>>> Stashed changes
