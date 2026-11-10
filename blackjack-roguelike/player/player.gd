extends CharacterBody2D


const SPEED = 60.0 #changed from 300 cuz he was zoomin
var screen_size
var last_direction



	
func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	if Input.is_action_pressed("move_right"):
		velocity.x +=1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	"""position = position.clamp(Vector2.ZERO, screen_size) - The player was getting stuck bc of 
	this since our floor is bigger than the screen size"""
	
	if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.animation = "walk NE"
		last_direction = "NE"
	elif Input.is_action_pressed("move_right") and Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.animation = "walk SE"
		last_direction = "SE"
	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.animation = "walk SW"
		last_direction = "SW"
	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.animation = "walk NW"
		last_direction = "NW"
	elif Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.animation = "walk E"
		last_direction = "E"
	elif Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.animation = "walk N"
		last_direction = "N"
	elif Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.animation = "walk W"
		last_direction = "W"
	elif Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.animation = "walk S"
		last_direction = "S"
	
	
