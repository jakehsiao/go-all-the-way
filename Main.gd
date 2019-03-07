extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var Game = preload("res://Game.tscn")
var game

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func new_game(difficulty=0.01):
	game = Game.instance()
	#game.name = "Game"
	add_child(game)
	
	game.difficulty = difficulty
	game.connect("pause", self, "pause")
	
func pause(reason):
	
	if reason == "game_over":
		print("game over!")
		$GameOver.show()
		
	elif reason == "win":
		#print("win!")
		$Win.show()


func _on_MainTitle_main_to_difficulty_selection():
	$MainTitle.hide()
	$Choice.show()

func _on_Choice_start_game(difficulty):
	new_game(difficulty)
	$Choice.hide()

func back_to_title():
	print("Coming back!")
	game.queue_free()
	$GameOver.hide()
	$Win.hide()
	$MainTitle.show()

func _on_GameOver_restart():
	var difficulty = game.difficulty
	game.queue_free()
	$GameOver.hide()
	new_game(difficulty)