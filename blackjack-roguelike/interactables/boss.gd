extends CharacterBody2D

func _ready():
	$Interactable.interact_name = "Fight Boss"
	$Interactable.interacted.connect(_on_interacted)
	
func _on_interacted():
	print("Interacted with Boss!")
