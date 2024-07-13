class_name Turtle extends Area2D

var speed
var changer : int
var hides

func _ready():
	if hides == false:
		$Timer.stop()
	$Sprite2D.frame = 0
	$Timer.wait_time= changer
	$CollisionShape2D.disabled = false

func _process(delta):
	position.x += speed * delta
	if position.x <= -16:
		queue_free()

func change_sprite():
	$Sprite2D.frame = 1
	await get_tree().create_timer(1.5, false).timeout
	$Sprite2D.frame = 2
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(1.5, false).timeout
	$Sprite2D.frame = 0
	$CollisionShape2D.disabled = false

func _on_timer_timeout():
	change_sprite()
