extends Control

const GAME_SCENE := "res://main.tscn"
const CONTROLS_SCENE := preload("res://controls/controls.tscn")

@onready var start_button: Button = $Buttons/Start
@onready var controls_button: Button = $Buttons/Controls
@onready var quit_button: Button = $Buttons/Quit
@onready var ship: TextureRect = $Logo/Line2/ShipHolder/Ship
@onready var foghorn: AudioStreamPlayer = $Foghorn

func _ready() -> void:
	start_button.pressed.connect(_on_start)
	controls_button.pressed.connect(_on_controls)
	quit_button.pressed.connect(func(): get_tree().quit())
	start_button.grab_focus() #so keyboard/controller works right away
	bob_ship()
	ship.gui_input.connect(_on_ship_clicked)

func _on_start() -> void:
	RunState.reset_run() #fresh run every time
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_controls() -> void:
	var c = CONTROLS_SCENE.instantiate()
	add_child(c)
	c.process_mode = Node.PROCESS_MODE_ALWAYS #controls only runs when paused normally, menu isnt paused
	c.back_pressed.connect(func(): controls_button.grab_focus())

func bob_ship() -> void:
	var t := create_tween().set_loops()
	t.tween_property(ship, "position:y", 3.0, 1.2).as_relative().set_trans(Tween.TRANS_SINE)
	t.tween_property(ship, "position:y", -3.0, 1.2).as_relative().set_trans(Tween.TRANS_SINE) #bobs forever

func _on_ship_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if foghorn.playing:
			return #no spamming it lol
		foghorn.play()
		var t := create_tween()
		for i in 3: #lil shudder when it honks
			t.tween_property(ship, "position:x", 2.0, 0.05).as_relative()
			t.tween_property(ship, "position:x", -2.0, 0.05).as_relative()
