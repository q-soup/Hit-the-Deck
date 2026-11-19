extends CanvasLayer

signal back_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	RunState.pause_toggled.connect(_on_pause_toggled)

func _on_pause_toggled(is_paused: bool):
	if not is_paused:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent):
		if event.is_action_pressed("pause"):
			get_viewport().set_input_as_handled()
			_close_controls()
			
func _on_back_button_pressed():
	_close_controls()
	
func _close_controls():
	back_pressed.emit()
	queue_free()
	
