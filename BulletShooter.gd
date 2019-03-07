extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal shoot_bullet(shooter, shoot_obj, direction)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	# connect
	var game = get_parent().get_parent()
	#if game.name == "Game":
	connect("shoot_bullet", game, "_on_Bullet_shooted")
	
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
	
func shoot():
	if $BulletShooterTimer.is_stopped():
		var parent = get_parent()
		var obj = parent.prior_object.get("entity_type")
		var direction = parent.position.angle_to_point(parent.prior_object.position)
		direction += PI
		emit_signal("shoot_bullet", parent, obj, direction)
		
		# Limit the shooter's waittime to 2 frames a shoot
		if $BulletShooterTimer.wait_time < 1 / 30:
			$BulletShooterTimer.wait_time = 1 / 30
		
		$BulletShooterTimer.start()
	