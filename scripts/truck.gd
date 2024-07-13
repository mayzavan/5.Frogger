class_name Truck extends Area2D

var speed

func _process(delta):
	position.x += speed * delta
	if position.x <= -36:
		queue_free()
