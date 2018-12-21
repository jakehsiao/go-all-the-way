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
	if game.name == "Game":
		connect("shoot_bullet", game, "_on_Bullet_shooted")
	
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
	
func shoot():
	if $BulletShooterTimer.is_stopped():
		var parent = get_parent()
		var obj = parent.prior_object
		var direction = parent.position.angle_to_point(obj.position)
		direction += PI
		emit_signal("shoot_bullet", parent, obj, direction)
		$BulletShooterTimer.start()
	