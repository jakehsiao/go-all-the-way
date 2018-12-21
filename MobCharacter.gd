extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed_scale = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var animations = [["fly", 2], ["walk", 1.5], ["swim", 1]]
	var chosen_anime = animations[randi() % animations.size()]
	$AnimatedSprite.animation = chosen_anime[0]
	speed_scale = chosen_anime[1]
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func play():
	$AnimatedSprite.play()


func _on_RandomWalker_moving():
	$AnimatedSprite.play()