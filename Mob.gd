extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var speed_min
export (int) var speed_max

var prior_object

var entity_type = "Mob"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	# Init properties
	$BulletShooter/BulletShooterTimer.wait_time = 0.5
	$MobBody/BodyFeature.hp = 10
	#$RandomWalker.toward_friend = 0.5
	
	pass
	
func set_speed(speed_scale):
	var speed_val = rand_range(speed_min, speed_max)
	speed_val *= speed_scale
	if speed_val > 200:
		speed_val = 200
	$RandomWalker.speed = speed_val
	
func set_scale(scale_val):
	scale *= scale_val
	$MobBody/BodyFeature.hp *= scale_val * scale_val
	
func set_attrs(gene):
	set_speed(sqrt(gene["speed"]))
	set_scale(rand_range(0.5, 1.5)) # This is totally random and indepent to gene
	$BulletShooter/BulletShooterTimer.wait_time *= 1 / gene["bullet_rate"]
	$MobBody/BodyFeature.hp *= gene["hp"]
	$Sensor.scale *= sqrt(gene["sensor_range"])
	

func get_prior_object():
	if $Sensor.friends_sensed.size() > 0:
		prior_object = $Sensor.friends_sensed[0]
	else:
		prior_object = null
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	get_prior_object()
		
	#print("Mob Range:", $Sensor/CollisionShape2D.shape.radius)
