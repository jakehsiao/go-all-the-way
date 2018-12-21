extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var shooter
var shoot_obj
export (int) var speed

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var velocity = Vector2()
	velocity.x = speed * cos(rotation)
	velocity.y = speed * sin(rotation)
	position += velocity * delta
	
func explode():
	set_process(false)
	$ColorRect.hide()
	$ShootedParticle.emit_once()

func _on_ShootedParticle_finish_emitting():
	queue_free()