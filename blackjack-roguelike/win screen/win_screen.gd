extends CanvasLayer

#connect stats and menu scene and emit when winning conditions are met
@export_file("*.tscn") var main_menu_scene: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_try_again_pressed() -> void:
	RunState.reset_run()
	#once menu scene is made, fix this 
	if main_menu_scene != "":
		get_tree().change_scene_to_file(main_menu_scene)
	else:
		print("Main Menu scene not assigned yet")
