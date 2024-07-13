extends Node

@export var frog_point : PackedScene
@export var wood3 : PackedScene
@export var wood5 : PackedScene
@export var wood6 : PackedScene
@export var turtle : PackedScene
@export var truck_scene : PackedScene
@export var car_scene : PackedScene
@export var spatter : PackedScene
@export var drowned : PackedScene

var score = 0
var lifes = 7
var frogsprites : Array
var on_object : bool = false

func _ready():
	Global.loadfile()
	$Rankings/Hiscore1.text = str(Global.hiscore1) + 'pts'
	$Rankings/Hiscore2.text = str(Global.hiscore2) + 'pts'
	$Rankings/Hiscore3.text = str(Global.hiscore3) + 'pts'
	$Rankings/Hiscore4.text = str(Global.hiscore4) + 'pts'
	$Rankings/Hiscore5.text = str(Global.hiscore5) + 'pts'
	$Loss.hide()
	$Win.hide()
	AudioServer.set_bus_mute(0, true)
	await get_tree().create_timer(4, false).timeout
	$GameStart.hide()
	await get_tree().create_timer(3, false).timeout
	$Rankings.hide()
	draw_lifes()
	await get_tree().create_timer(0.5, false).timeout
	AudioServer.set_bus_mute(0, false)
	$frog.can_move = true

func _process(delta):
	if lifes <= 0:
		game_finished()
	$UI/score.text = str(score)
	$UI/hiscore.text = str(Global.hiscore1)
	$UI/Panel.scale.x = $frog.time_left/30

func draw_lifes():
	for life in frogsprites:
		life.queue_free()
	frogsprites.clear()
	for a in lifes:
		var life = frog_point.instantiate()
		life.position = Vector2(8+16*a , 312)
		add_child(life)
		frogsprites.append(life)

func spawn_turtle(row):
	var d : bool
	var c = randf()
	if c >= 0.8:
		d = true
	else:
		d = false
	var b = randi_range(4,30)
	match row:
		1:
			for a in 2:
				var spawn
				spawn = turtle.instantiate()
				spawn.changer = b
				spawn.hides = d
				spawn.position.y = 106 + 16 * 1 
				spawn.position.x = 340 + 16*a
				spawn.speed = -50
				add_child(spawn)
		4:
			for a in 3:
				var spawn
				spawn = turtle.instantiate()
				spawn.changer = b
				spawn.hides = d
				spawn.position.y = 106 + 16 * 4
				spawn.position.x = 340 + 16*a
				spawn.speed = -75
				add_child(spawn)

func _on_wood_3_timeout():
	var wood
	wood = wood3.instantiate()
	wood.position.y = 106 + 16 * 3
	wood.position.x = -100
	wood.speed = 30
	add_child(wood)
	$Wood3.wait_time = randf_range(1.8,4)
func _on_wood_5_timeout():
	var wood
	wood = wood5.instantiate()
	wood.position.y = 106 + 16 * 0
	wood.position.x = -100
	wood.speed = 50
	add_child(wood)
	$Wood5.wait_time = randf_range(2,4)
func _on_wood_6_timeout():
	var wood
	wood = wood6.instantiate()
	wood.position.y = 106 + 16 * 2
	wood.position.x = -100
	wood.speed = 50
	add_child(wood)
	$Wood6.wait_time = randf_range(3,5)
func _on_turtle_1_timeout():
	spawn_turtle(1)
	spawn_turtle(1)
	$Turtle1.wait_time = randf_range(1,4)
func _on_turtle_4_timeout():
	spawn_turtle(4)
	spawn_turtle(4)
	spawn_turtle(4)
	$Turtle4.wait_time = randf_range(1,2)
func _on_truck_timeout():
	var truck
	truck = truck_scene.instantiate()
	truck.position.x = 340
	truck.position.y = 200
	truck.speed = -30
	add_child(truck)
	$Truck.wait_time = randf_range(1.2,4)
func _on_car_0_timeout():
	var car
	car = car_scene.instantiate()
	car.position.x = 340
	car.position.y = 200 + 16 * 1 + randi_range(0,4)
	car.speed = -70
	add_child(car)
	$Car0.wait_time = randf_range(0.2,4)
func _on_car_1_timeout():
	$FastCarSFX.play()
	await get_tree().create_timer(0.5, false).timeout
	var car
	var a = randf()
	var b
	if a <= 0.5:
		b = 1
	else:
		b = -1
	car = car_scene.instantiate()
	if b == 1:
		car.position.x = 340
		car.position.y = 200 + 16 * 2 
		car.speed = -300
	else:
		car.position.x = -16
		car.position.y = 200 + 16 * 2 
		car.speed = 300
	add_child(car)
	$Car1.wait_time = randf_range(1,7)
func _on_car_2_timeout():
	var car
	car = car_scene.instantiate()
	car.position.x = -16
	car.position.y = 200 + 16 * 3 - randi_range(0,4)
	car.rotation_degrees = 180
	car.speed = 80
	add_child(car)
	$Car2.wait_time = randf_range(0.2,4)
func _on_car_3_timeout():
	var car
	car = car_scene.instantiate()
	car.position.x = -16
	car.position.y = 200 + 16 * 4
	car.rotation_degrees = 180
	car.speed = 50
	add_child(car)
	$Car3.wait_time = randf_range(0.4,2)
func _on_honking_timer_timeout():
	$HonkingTimer.wait_time = randf_range(0.7,10)
	$HonkingSFX.play()

func death(what):
	var dead
	match what:
		0:
			dead = spatter.instantiate()
			dead.rotation_degrees = randf() * 180
		1:
			dead = drowned.instantiate()
	dead.position = $frog.position
	add_child(dead)

func game_finished():
	if lifes<=0:
		$Loss.show()
	else:
		$Win.show()
	$TileMap.hide()
	$frog.can_move = false
	$frog.hide()
	AudioServer.set_bus_mute(0, true)
	await get_tree().create_timer(2, false).timeout
	if score > Global.hiscore1:
		Global.hiscore5 = Global.hiscore4
		Global.hiscore4 = Global.hiscore3
		Global.hiscore3 = Global.hiscore2
		Global.hiscore2 = Global.hiscore1
		Global.hiscore1 = score
	elif score > Global.hiscore2:
		Global.hiscore5 = Global.hiscore4
		Global.hiscore4 = Global.hiscore3
		Global.hiscore3 = Global.hiscore2
		Global.hiscore2 = score
	elif score > Global.hiscore3:
		Global.hiscore5 = Global.hiscore4
		Global.hiscore4 = Global.hiscore3
		Global.hiscore3 = score
	elif score > Global.hiscore4:
		Global.hiscore5 = Global.hiscore4
		Global.hiscore4 = score
	elif score > Global.hiscore5:
		Global.hiscore5 = score
	Global.savefile()
	get_tree().reload_current_scene()
