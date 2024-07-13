class_name Car extends Area2D

var speed

func _ready():
	$Sprite2D.frame = randi_range(0,3)
func _process(delta):
	position.x += speed * delta
	if position.x >= 450 or position.x <= -36:
		queue_free()
