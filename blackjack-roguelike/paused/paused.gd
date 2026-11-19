extends CanvasLayer

const CONTROLS_SCENE = preload("res://controls/controls.tscn")

@onready var quit_confirm_panel: Control = $QuitConfirmPanel
#replace scene name for main menu
@export_file("*.tscn") var main_menu_scene: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	quit_confirm_panel.hide()
	RunState.pause_toggled.connect(_on_pause_toggled)
	
func _on_pause_toggled(is_paused: bool):
	visible = is_paused
	if not is_paused:
		quit_confirm_panel.hide()
	
func _on_resume_button_pressed():
	RunState.set_paused(false)
	
#connect signal and reset back to loading screen
func _on_quit_button_pressed():
	RunState.set_paused(false)
	get_tree().quit()
	
func _on_controls_button_pressed():
	visible = false
	var controls_instance = CONTROLS_SCENE.instantiate()
	controls_instance.back_pressed.connect(func(): visible = true)
	get_tree().root.add_child(controls_instance)

func _on_quit_pressed():
	quit_confirm_panel.show()
	
func _on_no_pressed():
	quit_confirm_panel.hide()
	
func _on_yes_pressed():
	RunState.set_paused(false)
	RunState.reset_run()
	#once menu scene is made, fix this 
	if main_menu_scene != "":
		get_tree().change_scene_to_file(main_menu_scene)
	else:
		print("Main Menu scene not assigned yet")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
