extends TextureRect

const SUITS = {"H": "Hearts", "D": "Diamonds", "C": "Clubs", "S": "Spades"}
const BACK = preload("res://art/cards/Back_1.png") #can pick any color later idm

func set_card(card: String, face_down := false) -> void: #card comes in like KH or 10S
	if face_down:
		texture = BACK
		return
	var rank := card.substr(0, card.length() - 1)
	if rank == "A":
		rank = "ACE" #files say ACE not A
	var suit: String = SUITS[card.right(1)]
	texture = load("res://art/cards/%s_%s.png" % [suit, rank]) #ex: Hearts_K.png
