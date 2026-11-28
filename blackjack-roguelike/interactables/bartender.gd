extends CharacterBody2D

const BARTENDER_SCENE: PackedScene = preload("res://interactables/bartender_scene.tscn")
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	$Interactable.interact_name = "Talk to Bartender"
	$Interactable.interacted.connect(interact)
	
func interact() -> void:
	print(["Hi there! What would you like to drink today!"])
	add_child(BARTENDER_SCENE.instantiate())
	
