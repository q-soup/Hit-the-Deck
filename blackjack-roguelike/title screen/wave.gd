extends TextureRect

@export var speed := 10.0 #set different per wave so it looks deep

func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x <= -32: 
		position.x += 32
