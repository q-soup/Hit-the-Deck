class_name Deck
extends RefCounted

var cards: Array[cardData] = []


func _init() -> void:
	build_deck()


func build_deck() -> void:
	cards.clear()

	for suit in cardData.Suit.values():
		for rank in cardData.Rank.values():
			var card := cardData.new()
			card.suit = suit
			card.rank = rank
			card.value = _get_blackjack_value(rank)

			cards.append(card)


func _get_blackjack_value(rank: int) -> int:
	if rank == cardData.Rank.ACE:
		return 11

	if rank == cardData.Rank.JACK \
	or rank == cardData.Rank.QUEEN \
	or rank == cardData.Rank.KING:
		return 10

	return rank


func shuffle() -> void:
	cards.shuffle()


func draw() -> cardData:
	if cards.is_empty():
		build_deck()
		shuffle()

	return cards.pop_back()


func remaining() -> int:
	return cards.size()
