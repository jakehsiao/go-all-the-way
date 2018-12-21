extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var prior_object
var player_control = false

var RandomWalker = preload("res://RandomWalker.tscn")
var Controller = preload("res://Controller.tscn")

var gene = {}

var display_name

var entity_type = "Friend"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	# Add Random walker
	var random_walker = RandomWalker.instance()
	add_child(random_walker)
	
	# Init template properties
	$BulletShooter/BulletShooterTimer.wait_time = 1
	$RandomWalker.speed = 100
	
	# Init name
	display_name = get_node("../NameGenerator").generate_name()
	$NameLabelContainer/NameLabel.text = display_name
	
func get_gene_attr(attr_name, scale_min, scale_max):
	# If attribute in gene, return that
	# Else, WRITE that into the gene, and return the random value generated
	if attr_name in gene.keys():
		return gene[attr_name]
	else:
		var val = rand_range(scale_min, scale_max)
		gene[attr_name] = val
		return val
		
func set_surname():
	if "surname" in gene.keys():
		display_name[0] = gene["surname"]
	else:
		gene["surname"] = display_name[0]
	# Name is displayed again after surname is set
	$NameLabelContainer/NameLabel.text = display_name

func set_scale(scale_val):
	scale *= scale_val
	$FriendBody/BodyFeature.hp *= scale_val * scale_val

func set_attrs():
	# Combat
	$BulletShooter/BulletShooterTimer.wait_time *= get_gene_attr("bullet_rate", 0.1, 2.0)
	$Sensor.scale *= get_gene_attr("sensor_range", 0.1, 2)
	# HP
	$FriendBody/BodyFeature.hp *= get_gene_attr("hp", 0.8, 1.2)
	# Speed
	$RandomWalker.speed *= get_gene_attr("speed", 0.25, 1.75)
	# Reproduction rate
	$FriendBody/MateFeature/MateTimer.wait_time *= get_gene_attr("mate_time", 0.25, 1.75)
	# Scale
	set_scale(get_gene_attr("scale", 0.5, 1.5))
	# Name
	set_surname()
	# Behaviour disposition
	$RandomWalker.toward_mob *= get_gene_attr("toward_mob", 0.4, 1.6)
	$RandomWalker.toward_friend *= get_gene_attr("toward_friend", 0.4, 1.6)
	
	
func switch_controller():
	# Change controller between player and random
	# Make sure they are symmetrical
	if player_control:
		get_node("Controller").replace_by(RandomWalker.instance())
		get_node("Sensor").sort_objects = false
		get_node("FriendBody/PlayerHealTimer").stop()
		
		player_control = false
	else:
		get_node("RandomWalker").replace_by(Controller.instance())
		get_node("Sensor").sort_objects = true
		get_node("FriendBody/PlayerHealTimer").start()
		
		rotation = 0
		player_control = true
	
func get_prior_object():
	if $Sensor.mobs_sensed.size() > 0:
		prior_object = $Sensor.mobs_sensed[0]
	elif $Sensor.friends_sensed.size() > 0:
		prior_object = $Sensor.friends_sensed[0]
	else:
		prior_object = null
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic herr
	get_prior_object()
	if prior_object and player_control:
		#print("Prior Object:", prior_object.name)
		pass