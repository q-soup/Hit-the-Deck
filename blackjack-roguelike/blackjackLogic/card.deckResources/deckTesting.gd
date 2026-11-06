extends SceneTree

func _initialize() -> void:
	_test_new_deck_has_52_unique_cards()
	_test_blackjack_values()
	_test_draw_removes_cards()
	_test_empty_deck_refills()

	print("DeckTest: all tests passed")
	quit()


func _test_new_deck_has_52_unique_cards() -> void:
	var deck := Deck.new()

	assert(
		deck.remaining() == 52,
        "A new deck must contain 52 cards"
	)

	var seen: Dictionary = {}

	for card in deck.cards:
		var key := "%s-%s" % [card.suit, card.rank]

		assert(
			not seen.has(key),
			"Duplicate card found: " + key
		)

		seen[key] = true

	assert(
		seen.size() == 52,
        "Deck must contain 52 unique cards"
	)


func _test_blackjack_values() -> void:
	var deck := Deck.new()
	var values_by_rank: Dictionary = {}

	for card in deck.cards:
		values_by_rank[card.rank] = card.value

	assert(
		values_by_rank[cardData.Rank.ACE] == 11,
        "Ace should start at 11"
	)

	assert(
		values_by_rank[cardData.Rank.TWO] == 2,
        "Two should be worth 2"
	)

	assert(
		values_by_rank[cardData.Rank.TEN] == 10,
        "Ten should be worth 10"
	)

	assert(
		values_by_rank[cardData.Rank.JACK] == 10,
        "Jack should be worth 10"
	)

	assert(
		values_by_rank[cardData.Rank.QUEEN] == 10,
        "Queen should be worth 10"
	)

	assert(
		values_by_rank[cardData.Rank.KING] == 10,
        "King should be worth 10"
	)


func _test_draw_removes_cards() -> void:
	var deck := Deck.new()

	var card := deck.draw()

	assert(card != null, "Draw must return a card")

	assert(
		deck.remaining() == 51,
        "Drawing once should leave 51 cards"
	)


func _test_empty_deck_refills() -> void:
	var deck := Deck.new()

	for i in range(52):
		var card := deck.draw()

		assert(
			card != null,
            "Drawing from a full deck should return a card"
		)

	assert(
		deck.remaining() == 0,
        "Deck should be empty after 52 draws"
	)

	var next_card := deck.draw()

	assert(
		next_card != null,
        "Drawing from an empty deck should refill it"
	)

	assert(
		deck.remaining() == 51,
        "Refilled deck should have 51 cards remaining"
	)
