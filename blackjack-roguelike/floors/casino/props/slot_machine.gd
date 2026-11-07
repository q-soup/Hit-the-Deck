extends StaticBody2D

@onready var sprite := $AnimatedSprite2D

func _ready():
	await get_tree().create_timer(randf_range(0.0, 3.0)).timeout
	cycle()

func cycle():
	while true:
		sprite.play("idle")
		await get_tree().create_timer(randf_range(2.0, 5.0)).timeout

		sprite.play("spin")
		await get_tree().create_timer(randf_range(1.5, 3.0)).timeout

		sprite.play("win" if randf() < 0.3 else "lose")
		await get_tree().create_timer(1.5).timeout
