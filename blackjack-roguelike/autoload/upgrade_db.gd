extends Node

const QUALITY_WEIGHT := {1: 60, 2: 25, 3: 10, 4: 5}
const QUALITY_NAME := {1: "Common", 2: "Uncommon", 3: "Rare", 4: "Legendary"}
const QUALITY_COLOR := {1: Color("c0cbdc"), 2: Color("63c74d"), 3: Color("0099db"), 4: Color("fee761")} #fortnite solved this for us lmao
const PRICE_BY_QUALITY := {1: 5, 2: 10, 3: 20, 4: 40}

const BASE_STATS := {
	"damage_mult": 1.0, "damage_flat": 0, "chips_mult": 1.0,
	"armor": 0, "max_hp": 0, "heal_on_win": 0, "thorns": 0.0,
	"dealer_stand": 17, "target": 21, "drink_slots": 1,
}

const ITEMS := {
	"soft_touch": {"name": "Soft Touch", "kind": "passive", "quality": 2, "icon": "res://art/ui/icons/soft_touch.png",
		"effects": {"dealer_stand": -2}, "desc": "Dealer must stand on 15"},
	"aim_24": {"name": "Aim for 24", "kind": "passive", "quality": 3, "icon": "res://art/ui/icons/aim_24.png",
		"effects": {"target": 3}, "desc": "Aim for 24 instead of 21"},
	"thorns": {"name": "Thorns", "kind": "passive", "quality": 2, "icon": "res://art/ui/icons/thorns.png",
		"effects": {"thorns": 0.03}, "desc": "Reflect 3% of damage taken"},
	"sharp_cards": {"name": "Sharp Cards", "kind": "passive", "quality": 1, "icon": "res://art/ui/icons/sharp_cards.png",
		"effects": {"damage_flat": 1}, "desc": "+1 damage"},
	"brass_knuckles": {"name": "Brass Knuckles", "kind": "dealer", "quality": 1,
		"effects": {"damage_flat": 3}, "desc": "Hits 3 harder"},
	"iron_liver": {"name": "Iron Liver", "kind": "dealer", "quality": 1,
		"effects": {"max_hp": 15}, "desc": "+15 max HP"},
	"padded_vest": {"name": "Padded Vest", "kind": "dealer", "quality": 1,
		"effects": {"armor": 2}, "desc": "Takes 2 less damage"},
	"barbed_chips": {"name": "Barbed Chips", "kind": "dealer", "quality": 2,
		"effects": {"thorns": 0.10}, "desc": "Reflects 10% of damage taken"},
	"bar_tab": {"name": "Bar Tab", "kind": "dealer", "quality": 2,
		"effects": {"heal_on_win": 5}, "desc": "Heals 5 HP when he wins a hand"},
	"captains_coat": {"name": "Captain's Coat", "kind": "dealer", "quality": 3,
		"effects": {"armor": 4, "max_hp": 30}, "desc": "Takes 4 less damage, +30 max HP"},
	"kraken_tooth": {"name": "Kraken Tooth", "kind": "dealer", "quality": 4,
		"effects": {"damage_flat": 10, "thorns": 0.15}, "desc": "Hits 10 harder, reflects 15%"},

	"starboard_ipa": {"name": "Starboard IPA", "kind": "drink", "quality": 1,
		"drunk_points": 2, "effects": {"damage_mult": 0.05}, "desc": "+5% damage"},
	"dockside_cider": {"name": "Dockside Cider", "kind": "drink", "quality": 1,
		"drunk_points": 2, "effects": {"chips_mult": 0.05}, "desc": "+5% chips from wins"},
	"anchor_ale": {"name": "Anchor Ale", "kind": "drink", "quality": 1,
		"drunk_points": 2, "effects": {"heal_on_win": 3}, "desc": "Heal 3 HP on every win"},
	"shipmate_sangria": {"name": "Shipmate Sangria", "kind": "drink", "quality": 3,
		"drunk_points": 3, "effects": {"drink_boost": 0.07}, "desc": "Boosts every other drink by 7%"},
	"virgin_mojito": {"name": "Virgin Voyage Mojito", "kind": "drink", "quality": 4,
		"drunk_points": 0, "effects": {"armor": 1}, "desc": "+1 armor, no drunk points"},
	"captains_reserve": {"name": "Captains Reserve", "kind": "drink", "quality": 4,
		"drunk_points": 5, "effects": {"damage_flat": 2, "max_hp": 10, "armor": 1, "drink_slots": 1},
		"desc": "+2 damage, +10 max HP, +1 armor, +1 drink slot"},
}

func price_of(id: String) -> int:
	return ITEMS[id].get("price", PRICE_BY_QUALITY[ITEMS[id].quality])

func ids_of(kind: String, quality := 0) -> Array:
	var out: Array = []
	for id in ITEMS:
		var item: Dictionary = ITEMS[id]
		var kind_ok: bool = item.kind == kind or (kind == "upgrade" and item.kind in ["passive", "active"]) #no drinks in the slot shop
		if kind_ok and (quality == 0 or item.quality == quality):
			out.append(id)
	return out

func roll_item(kind: String) -> String:
	var available: Array = []
	var total := 0
	for q in QUALITY_WEIGHT:
		if not ids_of(kind, q).is_empty():
			available.append(q)
			total += QUALITY_WEIGHT[q]
	if available.is_empty():
		return ""
	var r := randi() % total
	for q in available:
		r -= QUALITY_WEIGHT[q]
		if r < 0:
			return ids_of(kind, q).pick_random()
	return ids_of(kind, available[0]).pick_random()

func roll_item_of_quality(kind: String, quality: int) -> String:
	for q in range(quality, 0, -1):
		var pool := ids_of(kind, q)
		if not pool.is_empty():
			return pool.pick_random()
	return ""

func roll_items(kind: String, count: int) -> Array[String]:
	var out: Array[String] = []
	var tries := 0
	while out.size() < count and tries < 100:
		tries += 1
		var id := roll_item(kind)
		if id != "" and (id not in out or tries > 50):
			out.append(id)
	return out

func calc_stats(ids: Array) -> Dictionary:
	var stats := BASE_STATS.duplicate()
	var boost := 0.0
	for id in ids:
		boost += ITEMS[id].effects.get("drink_boost", 0.0)
	for id in ids:
		var item: Dictionary = ITEMS[id]
		var scale := (1.0 + boost) if item.kind == "drink" else 1.0
		for key in item.effects:
			if key == "drink_boost":
				continue
			var value = item.effects[key]
			if key in ["damage_mult", "chips_mult", "thorns"]:
				value *= scale
			stats[key] += value
	return stats
