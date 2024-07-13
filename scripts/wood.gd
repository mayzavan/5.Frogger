class_name Wood extends Area2D

var speed

func _process(delta):
	position.x += speed * delta
	if position.x >= 430:
		queue_free()
