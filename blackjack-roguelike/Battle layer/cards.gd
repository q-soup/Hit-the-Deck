extends TextureRect

const SHEET = preload("res://art/cards/poker_cards.png")
const W := 48
const H := 64
const SUIT_ROW = {"H": 0, "D": 1, "S": 2, "C": 3} #preload row by row
const RANKS = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
const BACK_COL := 4 #blue

func set_card(card: String, face_down := false) -> void: #card comes in like KH or 10S
	var col := BACK_COL
	var row := 4
	if not face_down:
		col = RANKS.find(card.substr(0, card.length() - 1)) #rank = everything but the last char
		row = SUIT_ROW[card.right(1)]
	var atlas := AtlasTexture.new()
	atlas.atlas = SHEET
	atlas.region = Rect2(col * W, row * H, W, H) #cuts card out of the sheet
	texture = atlas
