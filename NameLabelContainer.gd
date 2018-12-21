extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var parent

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	parent = get_parent()
	scale = parent.scale
	set_as_toplevel(true)
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	#rotation += parent.rotation
	position = parent.position