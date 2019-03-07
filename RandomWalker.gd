extends Node
#
#NEED CONFIG:
	# Prior object from parent
	# Speed from parent


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var parent # not able to defined here? = get_parent?
var screensize

var toward_friend = 1
var toward_mob = 1
var dashing = false

export (int) var speed = 100

signal moving

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	parent = get_parent()
	screensize = parent.get_viewport_rect().size
	
func dash(obj, disposition):
	var dash_direction = parent.position.angle_to_point(obj.position)
	var dash_distance = parent.position.distance_to(obj.position)
	if dash_distance > 20: # Or they will overlap a lot
		if disposition > 2:
			dashing = true
			parent.rotation = dash_direction - PI / 2 # -PI/2 to remain the same as sprite direction
		elif disposition < 1:
			dashing = true
			parent.rotation = dash_direction - PI - PI / 2 # Same as above
		else:
			dashing = false

func process(delta):
	# Change the rotation randomly
	var delta_psi = 0
	var change_amount = randf()
	if change_amount > 0.95:
		delta_psi = change_amount * 0.5 * PI / 3
		
	delta_psi *= (randi() % 2) * 2 - 1
	
	parent.rotation += delta_psi

	
func _process(delta):
	# Change name to change the process function
	
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	# Change the rotation randomly
	var delta_psi = 0
	var change_amount = randf()
	if change_amount > 0.95:
		delta_psi = change_amount * 0.5 * PI / 3
		
	delta_psi *= (randi() % 2) * 2 - 1
	
	parent.rotation += delta_psi
	
	# Dash or not
	if parent.prior_object:
		if "Friend" in parent.prior_object.name:
			dash(parent.prior_object, toward_friend)
		
		elif "Mob" in parent.prior_object.name:
			dash(parent.prior_object, toward_mob)
	else:
		dashing = false
			
	# Move
	var orientation = parent.rotation + PI / 2
	var current_speed = speed
	if dashing:
		current_speed *= 2
	# Speed limit
	if current_speed > 200:
		current_speed = 200
	parent.position += Vector2(-cos(orientation), -sin(orientation)) * current_speed * delta
	
	
	# Flip when hit the edge
	if parent.position.x < 0:
		parent.rotation = PI / 2
		
	if parent.position.x > screensize.x:
		parent.rotation = - PI / 2
		
	if parent.position.y < 0:
		parent.rotation = PI
		
	if parent.position.y > screensize.y:
		parent.rotation = 0
	# Round the poisition
	parent.position.x = clamp(parent.position.x, 0, screensize.x)
	parent.position.y = clamp(parent.position.y, 0, screensize.y)
		
			

	# Play Anime
	parent.get_node("AnimatedSprite").play()
	
	# Shoot
	# EH: if node_exist then
	var obj = parent.prior_object
	if obj:
		if ("Mob" in obj.name and "Friend" in parent.name) or ("Mob" in parent.name and "Friend" in obj.name):
			get_node("../BulletShooter").shoot()