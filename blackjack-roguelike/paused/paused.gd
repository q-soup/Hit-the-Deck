extends CanvasLayer

const CONTROLS_SCENE = preload("res://controls/controls.tscn")

@onready var quit_confirm_panel: Control = $QuitConfirmPanel

@export_file("*.tscn") var main_menu_scene: String = "res://title screen/title_screen.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	quit_confirm_panel.hide()
	RunState.pause_toggled.connect(_on_pause_toggled)
	
func _on_pause_toggled(is_paused: bool):
	get_tree().paused = true
	visible = is_paused
	if not is_paused:
		quit_confirm_panel.hide()
	
func _on_resume_button_pressed():
	RunState.set_paused(false)
	get_tree().paused = false
	
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
	get_tree().paused = false
	RunState.reset_run()
	get_tree().change_scene_to_file(main_menu_scene)
