extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var img = Image.new()
	img.load("res://heart.png")
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	texture = tex

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
