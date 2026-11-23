@tool
extends TextureRect

@export var suit: Texture2D: #pick spade/club/etc per pennant in the inspector
	set(value):
		suit = value
		if is_node_ready():
			$Suit.texture = value

func _ready() -> void:
	$Suit.texture = suit
