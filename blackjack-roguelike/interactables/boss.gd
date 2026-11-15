extends CharacterBody2D

signal battle_requested(boss)
var defeated := false
@export var max_hp := 50 #set per enemy in the inspector
@export var damage := 10

func _ready():
	add_to_group("boss")
	$Interactable.interact_name = "Fight Boss"
	$Interactable.interacted.connect(interact)

func interact() -> void:
	if defeated:
		start_dialogue(["Nice game. Go on, you earned it."])
	else:
		battle_requested.emit(self)

func on_defeated() -> void:
	defeated = true
	start_dialogue(["You beat me...", "Take this."])

func on_lost() -> void:
	start_dialogue(["Better luck next time."])

func start_dialogue(lines: Array) -> void:
	print(lines)
