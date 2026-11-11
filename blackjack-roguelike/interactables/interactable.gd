extends Area2D
class_name InteractionArea
signal interacted

@export var interact_name: String = "Interact"
@export var is_interactable: bool = true

@onready var prompt: Label = $InteractionPrompt

var player_in_range: bool = false

var interact: Callable = func():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prompt.text = "[F] " + interact_name
	prompt.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and is_interactable:
		if Input.is_action_just_pressed("interact"):
			trigger_interaction()
			
func trigger_interaction():
	if not is_interactable:
		return
	interacted.emit()
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		prompt.visible = is_interactable
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		prompt.visible = false
		
