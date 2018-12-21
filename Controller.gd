extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# NEED CONFIG: speed


var parent # not able to defined here? = get_parent?
var screensize

export (int) var speed = 400

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	parent = get_parent()
	screensize = parent.get_viewport_rect().size
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	var velocity = Vector2() # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		parent.get_node("AnimatedSprite").play()
		parent.get_node("PlayerParticle").emitting = true
	else:
		parent.get_node("AnimatedSprite").stop()
		parent.get_node("PlayerParticle").emitting = false
			
	if Input.is_key_pressed(KEY_SPACE) and parent.prior_object:
		#get_tree().paused = true
		parent.get_node("BulletShooter").shoot()
		
	parent.position += velocity * delta
	parent.position.x = clamp(parent.position.x, 0, screensize.x)
	parent.position.y = clamp(parent.position.y, 0, screensize.y)
	