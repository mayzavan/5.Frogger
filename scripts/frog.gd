class_name Frog extends CharacterBody2D

var can_move = false
var distance = 16
var tile
var start = Vector2(152,280)
var lillypads_done = 0
var time_left = 30
var playing = false
var movecd = false

@export var tilemap : TileMap

signal scored
var main = null

func _ready():
	main = get_owner()
	position = start

func _process(delta):
	if playing:
		time_left -= delta
	if position.x > 320 or position.x < 0:
		main.lifes -= 1
		position = start
		main.draw_lifes()
		time_left = 30
	if position.y== 168: #turtle
		position.x += -75 * delta
	elif position.y == 152: #wood
		position.x += 30 * delta
	elif position.y == 136: #wood
		position.x += 50 * delta
	elif position.y == 120: #turtle
		position.x += -50 * delta
	elif position.y == 104: #wood
		position.x += 50 * delta
	if lillypads_done >= 5:
		main.score += 1000
		lillypads_done = 0
		main.game_finished()
	if time_left <= 0:
		main.death(0)
		main.lifes -= 1
		position = start
		main.draw_lifes()
		playing = false
		time_left = 30
	tile = check_tile()
	if tile == 'Road' and $CollisionShape2D/On.is_colliding():
		main.death(0)
		$HitSFX.play()
		main.lifes -= 1
		position = start
		main.draw_lifes()
		playing = false
		time_left = 30

func _input(event):
	if can_move and !movecd:
		if Input.is_action_just_pressed('left'):
			dont_spam_buttons_please()
			rotation_degrees = -90
			position.x -= distance
			await get_tree().create_timer(0.2, false).timeout
			walk_check()
			$MoveSFX.play()
			if playing == false:
				playing = true
			if randf() >= 0.95:
				make_sound()
		elif Input.is_action_just_pressed('right'):
			dont_spam_buttons_please()
			rotation_degrees = 90
			position.x += distance
			await get_tree().create_timer(0.2, false).timeout
			walk_check()
			$MoveSFX.play()
			if playing == false:
				playing = true
			if randf() >= 0.95:
				make_sound()
		elif Input.is_action_just_pressed('up') and position.y >= 72:
			dont_spam_buttons_please()
			rotation_degrees = 0
			position.y -= distance
			await get_tree().create_timer(0.2, false).timeout
			walk_check()
			$MoveSFX.play()
			main.score += 10
			if playing == false:
				playing = true
			if randf() >= 0.95:
				make_sound()
		elif Input.is_action_just_pressed('down') and position.y <= 264:
			dont_spam_buttons_please()
			rotation_degrees = 180
			position.y += distance
			await get_tree().create_timer(0.2, false).timeout
			walk_check()
			$MoveSFX.play()
			main.score -= 10
			if playing == false:
				playing = true
			if randf() >= 0.95:
				make_sound()

func check_tile():
	var data = tilemap.get_cell_tile_data(0, check_coords())
	if data != null:
		var type = data.get_custom_data('type')
		return type

func check_coords():
	var tile_coords = tilemap.local_to_map(tilemap.to_local(position))
	return tile_coords

func walk_check():
	tile = check_tile()
	if (tile == 'Water' or tile == 'Frog0' or tile == 'Frog1' or tile == 'Frog2' or tile == 'Frog3'):
		if $CollisionShape2D/On.is_colliding():
			pass
		else:
			main.death(1)
			$PlumSFX.play()
			main.lifes -= 1
			position = start
			main.draw_lifes()
			playing = false
			time_left = 30
	elif tile == 'Lilypad0':
		$ScoredSFX.play()
		main.score += int(10 * time_left)
		scored.emit()
		var walkin_coords = check_coords()
		tilemap.set_cell(0, Vector2(walkin_coords.x, walkin_coords.y),4,Vector2i(2,1))
		tilemap.set_cell(0, Vector2(walkin_coords.x + 1, walkin_coords.y),4,Vector2i(3,1))
		tilemap.set_cell(0, Vector2(walkin_coords.x  + 1, walkin_coords.y  + 1),4,Vector2i(3,2))
		tilemap.set_cell(0, Vector2(walkin_coords.x, walkin_coords.y  + 1),4,Vector2i(2,2))
		main.score += 50
		position = start
		playing = false
		time_left = 30
		lillypads_done += 1
	elif tile == 'Lilypad1':
		$ScoredSFX.play()
		main.score += int(10 * time_left)
		scored.emit()
		var walkin_coords = check_coords()
		tilemap.set_cell(0, Vector2(walkin_coords.x -1, walkin_coords.y),4,Vector2i(2,1))
		tilemap.set_cell(0, Vector2(walkin_coords.x, walkin_coords.y),4,Vector2i(3,1))
		tilemap.set_cell(0, Vector2(walkin_coords.x, walkin_coords.y  + 1),4,Vector2i(3,2))
		tilemap.set_cell(0, Vector2(walkin_coords.x - 1, walkin_coords.y  + 1),4,Vector2i(2,2))
		main.score += 50
		position = start
		playing = false
		time_left = 30
		lillypads_done += 1
	elif tile == 'Lilypad2':
		$ScoredSFX.play()
		main.score += int(10 * time_left)
		scored.emit()
		var walkin_coords = check_coords()
		tilemap.set_cell(0, Vector2(walkin_coords.x, walkin_coords.y - 1),4,Vector2i(2,1))
		tilemap.set_cell(0, Vector2(walkin_coords.x + 1, walkin_coords.y - 1),4,Vector2i(3,1))
		tilemap.set_cell(0, Vector2(walkin_coords.x +1, walkin_coords.y),4,Vector2i(3,2))
		tilemap.set_cell(0, Vector2(walkin_coords.x, walkin_coords.y),4,Vector2i(2,2))
		main.score += 50
		position = start
		playing = false
		time_left = 30
		lillypads_done += 1
	elif tile == 'Lilypad3':
		$ScoredSFX.play()
		main.score += int(10 * time_left)
		scored.emit()
		var walkin_coords = check_coords()
		tilemap.set_cell(0, Vector2(walkin_coords.x -1, walkin_coords.y-1),4,Vector2i(2,1))
		tilemap.set_cell(0, Vector2(walkin_coords.x, walkin_coords.y-1),4,Vector2i(3,1))
		tilemap.set_cell(0, Vector2(walkin_coords.x, walkin_coords.y),4,Vector2i(3,2))
		tilemap.set_cell(0, Vector2(walkin_coords.x  - 1, walkin_coords.y),4,Vector2i(2,2))
		main.score += 50
		position = start
		playing = false
		time_left = 30
		lillypads_done += 1

func make_sound():
	$FrogSFX.play()
	await get_tree().create_timer(0.2, false).timeout
	$FrogSFX.play()

func dont_spam_buttons_please():
	movecd = true
	await get_tree().create_timer(0.1, false).timeout
	movecd = false
