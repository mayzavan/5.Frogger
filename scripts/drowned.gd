extends Sprite2D

func _ready():
	frame = 0
	await get_tree().create_timer(0.25, false).timeout
	frame = 1
	await get_tree().create_timer(0.5, false).timeout
	frame = 2
	await get_tree().create_timer(1, false).timeout
	queue_free()
