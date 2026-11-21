class_name DealerData
extends RefCounted

const BASE_HP := 30
const BASE_DMG := 8
const MAX_ITEM_QUALITY := 4

const FLOOR_LEVELS := {
	1: Vector2i(1, 7),
	2: Vector2i(6, 13),
	3: Vector2i(12, 20),
}

var level := 1
var max_hp := 0
var hp := 0
var damage := 0
var items: Array[String] = []
var stats: Dictionary = {}

static func create(lvl: int) -> DealerData:
	var d := DealerData.new()
	d.level = lvl
	d._roll_loadout()
	d.stats = UpgradeDB.calc_stats(d.items)
	d.max_hp = BASE_HP * lvl + d.stats.max_hp
	d.hp = d.max_hp
	d.damage = roundi(BASE_DMG * (1.0 + (lvl - 1) * 0.5)) + d.stats.damage_flat
	return d

# Spend `level` points of budget. Each item costs its quality.
func _roll_loadout() -> void:
	var budget := level
	while budget > 0:
		var q := randi_range(1, mini(MAX_ITEM_QUALITY, budget))
		var id := UpgradeDB.roll_item_of_quality("dealer", q)
		if id == "":
			break
		items.append(id)
		budget -= q

static func level_range_for_floor(floor_num: int) -> Vector2i:
	return FLOOR_LEVELS.get(floor_num, FLOOR_LEVELS[FLOOR_LEVELS.keys().max()])

static func roll_level_for_floor(floor_num: int) -> int:
	var r := level_range_for_floor(floor_num)
	return randi_range(r.x, r.y)
