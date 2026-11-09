extends Node

const RANKS = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
const SUITS = ["H", "D", "C", "S"]

var deck: Array[String] = []
var player_hand: Array[String] = []
var dealer_hand: Array[String] = []
var round_over := false

signal round_ended(result: String, message: String)

func build_deck() -> void:
	deck.clear()
	for suit in SUITS:
		for rank in RANKS:
			deck.append(rank + suit)
	deck.shuffle()  


func draw_card() -> String:
	if deck.is_empty():
		build_deck()
	return deck.pop_back()  


func card_value(card: String) -> int:
	var rank := card.substr(0, card.length() - 1)  
	if rank in ["J", "Q", "K"]:
		return 10
	if rank == "A":
		return 11
	return int(rank)


func hand_value(hand: Array[String]) -> int:
	var total := 0
	var aces := 0
	for card in hand:
		total += card_value(card)
		if card.begins_with("A"):
			aces += 1

	while total > 21 and aces > 0:
		total -= 10
		aces -= 1
	return total

func is_soft(hand: Array[String]) -> bool:
	var total := 0
	var aces := 0
	for card in hand:
		total += card_value(card)
		if card.begins_with("A"):
			aces += 1

	while total > 21 and aces > 0:
		total -= 10
		aces -= 1

	# If an ace is still left over, it's counting as 11, so the hand is soft
	return aces > 0

func start_round() -> void:
	build_deck()
	player_hand.clear()
	dealer_hand.clear()
	round_over = false

	player_hand.append(draw_card())
	dealer_hand.append(draw_card())
	player_hand.append(draw_card())
	dealer_hand.append(draw_card())

	print("Player: ", player_hand, " = ", hand_value(player_hand))
	print("Dealer shows: ", dealer_hand[0])

	if hand_value(player_hand) == 21:
		stand()  


func hit() -> void:
	if round_over:
		return
	player_hand.append(draw_card())
	print("Player: ", player_hand, " = ", hand_value(player_hand))
	if hand_value(player_hand) > 21:
		end_round("lose", "Bust! Dealer wins.")


func stand() -> void:
	if round_over:
		return

	while hand_value(dealer_hand) < 17 or (hand_value(dealer_hand) == 17 and is_soft(dealer_hand)):
		dealer_hand.append(draw_card())

	var p := hand_value(player_hand)
	var d := hand_value(dealer_hand)
	print("Dealer: ", dealer_hand, " = ", d)

	if d > 21 or p > d:
		end_round("win", "You win!")
	elif p == d:
		end_round("push","Push (tie).")
	else:
		end_round("lose", "Dealer wins.")


func end_round(result: String, message: String) -> void:
	round_over = true
	print(message)
	round_ended.emit(result, message)
