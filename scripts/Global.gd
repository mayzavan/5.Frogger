extends Node

var location = "user://save_data.dat"

var hiscore1 : int
var hiscore2 : int
var hiscore3 : int
var hiscore4 : int
var hiscore5 : int
var highscores : Array

func savefile():
	highscores = [hiscore1, hiscore2, hiscore3, hiscore4, hiscore5]
	var file = FileAccess.open(location, FileAccess.WRITE)
	file.store_var(highscores)
	print("game saved")

func loadfile():
	if FileAccess.file_exists(location):
		print("game loaded")
		var file = FileAccess.open(location, FileAccess.READ)
		highscores = file.get_var()
	else:
		print("file not found")
		highscores = [0,0,0,0,0]
	
	hiscore1 = highscores[0]
	hiscore2 = highscores[1]
	hiscore3 = highscores[2]
	hiscore4 = highscores[3]
	hiscore5 = highscores[4]
