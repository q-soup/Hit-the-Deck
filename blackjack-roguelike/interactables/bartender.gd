extends CharacterBody2D

const BARTENDER_SCENE: PackedScene = preload("res://interactables/bartender_scene.tscn")
@onready var sprite = $CharacterBody2D

func _ready():
	add_to_group("bartender")
	$Interactable.interact_name = "Talk to Bartender"
	$Interactable.interacted.connect(interact)
	
func interact() -> void:
	print(["Hi there! What would you like to drink today!"])
	add_child(BARTENDER_SCENE.instantiate())
	
