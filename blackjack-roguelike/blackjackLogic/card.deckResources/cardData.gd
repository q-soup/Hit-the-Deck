class_name cardData
extends Resource

enum Suit {
	HEARTS,
	DIAMONDS,
	CLUBS,
	SPADES,
}

enum Rank {
	TWO = 2,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	NINE,
	TEN,
	JACK,
	QUEEN,
	KING,
	ACE
}

@export var suit: Suit = Suit.HEARTS
@export var rank: Rank = Rank.ACE
@export var value: int = 11

func get_rank_label() -> String:
	match rank:
		Rank.JACK:
			return "J"
		Rank.QUEEN:
			return "Q"
		Rank.KING:
			return "K"
		Rank.ACE:
			return "A"
		_:
			return str(rank)
			
func get_suit_label() -> String:
	match suit:
		Suit.HEARTS:
			return "H"
		Suit.DIAMONDS:
			return "D"
		Suit.CLUBS:
			return "C"
		Suit.SPADES:
			return "S"
		_:
			return "?"


func to_label() -> String:
	return get_rank_label() + get_suit_label()
