extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	RunState.pause_toggled.connect(_on_pause_toggled)
	
func _on_pause_toggled(is_paused: bool):
	visible = is_paused
	
func _on_resume_button_pressed():
	RunState.set_paused(false)
	
func _on_quit_button_pressed():
	RunState.set_paused(false)
	get_tree().quit()
	
#func _on_controls_button_pressed():
	#connect to button and make another canvaslayer showing controls


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
