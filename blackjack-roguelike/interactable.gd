extends Area2D

@export var interact_name: String = "Interact"
@export var is_interactable: bool = true

var interact: Callable = func():
	print("Interacted with default action")
	
func trigger_interaction():
	if is_interactable and interact.is_valid():
		interact.call()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
