extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal start_game(difficulty)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():
	emit_signal("start_game", "easy")

func _on_Button2_pressed():
	emit_signal("start_game", "medium")

func _on_Button3_pressed():
	emit_signal("start_game", "hard")