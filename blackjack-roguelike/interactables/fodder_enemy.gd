extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
var defeated := false
signal battle_requested(fodder_enemy)


func _ready():
	add_to_group("fodder_enemy")
	$Interactable.interact_name = "Fight Enemy"
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

	
