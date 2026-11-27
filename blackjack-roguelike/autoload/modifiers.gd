extends Node
class_name Modifiers

# ========================
# RARITY
# ========================

const RARITY_WEIGHT := {
	1: 70, 		#COMMON
	2: 25, 		#RARE
	3: 5, 		#LEGENDARY
}
const RARITY_NAME := {
	1: "Common",
	2: "Rare",
	3: "Lengendary",
}
const PRICE_BY_RARITY := {
	1: 5,		#COMMON
	2: 25,		#RARE
	3: 60,		#LEGENDARY
}

# ========================
# BASE STATS
# ========================

const BASE_STATS := {
	"damage_mult": 1.0,
	"damage_flat": 0,
	"chips_mult": 1.0,
	"chips_win_bonus": 0.0,

	"armor": 0,
	"max_hp": 0,

	"heal_on_win": 0,
	"heal_on_loss": 0,
	"heal_win_percent": 0.0,
	"heal_loss_percent": 0.0,
	"push_heal": 0,

	"thorns": 0.0,
	"refund_loss": 0.0,

	"dealer_stand": 17,
	"target": 21,

	"drink_slots": 1,
	"drink_boost": 0.0,
	"stat_bonus": 0.0,
	"drunk_bonus": 0.0,

	"wasted_no_force_hit": false,
	"drunk_immunity": false,
	"curse_immunity_floor": false,
}

# ========================
# DRINKS
# ========================

const DRINKS := {

	# ========================
	# COMMON
	# ========================

		"sunrise_mimosa": {
			"name": "Sunrise Mimosa",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 3,
			"effect": {
				"heal_win_percent": 0.03,
				"heal_loss_percent": 0.005,
			},
			"desc" : "Heals 3% of your health on wins and 0.5% on losses",
		},
		"dockside_cider": {
			"name": "Dockside Cider",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 2, 
			"effect": {
				"chips_mult": 0.05,
			}, 
			"desc": "Gain 5% more chips from wins.",
		},
		"sea_water": {
			"name": "Sea Water",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 2, 
			"effect": {
				"stat_bonus": 0.02,
			}, 
			"desc": "Increase all stats by 2%.",
		},
		"starboard_ipa": {
			"name": "Starboard IPA",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 2, 
			"effect": {
				"damage_mult": 0.05,
			}, 
			"desc": "Deal 5% more damage.",
		},
		"sea_snake": {
			"name": "Sea Snake",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 2, 
			"effect": {
				"thorns": 0.03,
			}, 
			"desc": "Reflects 3% of damage taken back to the dealer.",
		},
		"lifeboat_lager": {
			"name": "Lifeboat Lager",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 2, 
			"effect": {
				"refund_loss": 0.05,
			}, 
			"desc": "Refunds 5% of your bet after every lost hand.",
		},
		"pier_pressure": {
			"name": "Pier Pressure",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 2, 
			"effect": {
				"chip_win_bonus": 0.10,
			}, 
			"desc": "Gain 10% more chips on wins.",
		},
		"anchor_ale": {
			"name": "Anchor Ale",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 2, 
			"effect": {
				"heal_on_win": 3,
				"push_heal": 2,
			}, 
			"desc": "Heals 3 HP on every win and 2 on every push. No heal on loss.",
		},
		"golden_doubloon": {
			"name": "Golden Doubloon",
			"kind": "drink",
			"rarity": 1,
			"drunk_points": 2, 
			"effect": {
				"chips_win_bonus": 0.10,
			}, 
			"desc": "Gain 10% more chips on win.",
		},

	# ========================
	# RARE
	# ========================

		"shipmate_sangria": {
			"name": "",
			"kind": "drink",
			"rarity": 2,
			"drunk_points": 3, 
			"effect": {
				"drink_boost": 0.07,
			}, 
			"desc": "Boost the effects of every other drink by 7%",
		},
		
	# ========================
	# LEGENDARY
	# ========================

		"virgin_voyage_mojito": {
			"name": "Virgin Voyage Mojito",
			"kind": "drink",
			"rarity": 3,
			"drunk_points": 0, 
			"effect": {
				"armor": 1,
				"drunk_immunity": true,
				"curse_immunity_floor": true,
			}, 
			"desc": "Ignore drunk effects, become immune to drink curses for this floor, and gain +1 armor.",
		},
		"boardwalk_bubbly": {
			"name": "Boardwalk Bubbly",
			"kind": "drink",
			"rarity": 3,
			"drunk_points": 1, 
			"effect": {
				"drunk_bonus": 0.50,
				"wasted_np_force_hit": true,
			}, 
			"desc": "Make drunk level bonuses 50% stronger and being wasted no longer forces you to hit. ",
		},
		"captains_reserve": {
			"name": "Captain's Reserve",
			"kind": "drink",
			"rarity": 3,
			"drunk_points": 5, 
			"effect": {
				"damage_flat": 2,
				"max_hp": 10,
				"armor": 1,
				"drink_slots": 1,
			}, 
			"desc": "Gain +2 damage, +10 maximum HP, and +1 drink slot",
		},
}
# ========================
# DRINK LOOKUP 
# ========================

static func price_of(id: String) -> int:
	if not DRINKS.has(id):
		return 0
	
	var rarity: int = DRINKS[id].get("rarity", 1)
	return PRICE_BY_RARITY.get(rarity, 0)
	
static func ids_of(rarity: int = 0) -> Array[String]:
	var result: Array[String] = []

	for id in DRINKS:
		if rarity == 0 or DRINKS[id].get("rarity", 1) == rarity:
			result.append(id)

	return result


static func roll_item() -> String:
	var total_weight := 0

	for rarity in RARITY_WEIGHT:
		total_weight += RARITY_WEIGHT[rarity]

	var roll := randi_range(1, total_weight)
	var selected_rarity := 1

	for rarity in RARITY_WEIGHT:
		roll -= RARITY_WEIGHT[rarity]

		if roll <= 0:
			selected_rarity = rarity
			break

	return roll_item_of_quality(selected_rarity)


static func roll_item_of_quality(rarity: int) -> String:
	var available := ids_of(rarity)

	if available.is_empty():
		return ""

	return available.pick_random()


static func roll_items(count: int) -> Array[String]:
	var result: Array[String] = []

	for i in range(count):
		var id := roll_item()

		if id != "":
			result.append(id)

	return result


# ========================
# STAT CALCULATION
# ========================

static func calc_stats(inventory: Array[String]) -> Dictionary:
	var result := BASE_STATS.duplicate(true)

	# First determine whether any drink boosts the others.
	for id in inventory:
		if not DRINKS.has(id):
			continue

		var effect: Dictionary = DRINKS[id].get("effect", {})
		result["drink_boost"] += effect.get("drink_boost", 0.0)

	# Apply each drink's effects.
	for id in inventory:
		if not DRINKS.has(id):
			continue

		var effect: Dictionary = DRINKS[id].get("effect", {})
		var is_sangria := effect.has("drink_boost")

		var multiplier := 1.0
		if not is_sangria:
			multiplier += result["drink_boost"]

		for stat in effect:
			if stat == "drink_boost":
				continue

			var value = effect[stat]

			if typeof(value) == TYPE_BOOL:
				result[stat] = result.get(stat, false) or value
			elif typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT:
				result[stat] = result.get(stat, 0) + value * multiplier

	# Convert stats that must be whole numbers.
	result["damage_flat"] = roundi(result["damage_flat"])
	result["armor"] = roundi(result["armor"])
	result["max_hp"] = roundi(result["max_hp"])
	result["heal_on_win"] = roundi(result["heal_on_win"])
	result["heal_on_loss"] = roundi(result["heal_on_loss"])
	result["push_heal"] = roundi(result["push_heal"])
	result["drink_slots"] = roundi(result["drink_slots"])

	return result
