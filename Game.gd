extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var Friend = preload("res://Friend.tscn")
var Mob = preload("res://Mob.tscn")
var Bullet = preload("res://Bullet.tscn")

var Player

var score = 0

var screensize

var spawn_count = 0
var unit_count = 0
	

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
#
#	# Test player
##
#	Player = add_player()
#
#	# Test friends
#
#	for i in range(1):
#		var friend = Friend.instance()
#		add_child(friend)
#
#		friend.position = Vector2(randi()% 600, randi() % 300)
	randomize()

	screensize = $Score.get_viewport_rect().size

	# Play the game
	gameplay()
	
	# Test the performance
#	for i in range(50):
#		add_friend(Vector2(rand_range(0, 500), rand_range(0,500)))
#		add_mob(Vector2(rand_range(600, 800), rand_range(0, 500)))
#	add_player()
#
	
func add_player():
	var player = Friend.instance()
	add_child(player)
	
	# Set player's property here
	player.position = Vector2(300, 300)
	player.get_node("FriendBody/MateFeature/MateTimer").wait_time = 0.5
	player.get_node("BulletShooter/BulletShooterTimer").wait_time = 0.25
	player.get_node("FriendBody/BodyFeature").hp = 20
	
	
	player.switch_controller() # Place all player settings inside this function
	
	# Set player's gene
	player.gene = {
		"bullet_rate": 0.5, # To balance the game, bullet_rate is set 0.5
		"sensor_range": 1,
		"hp": 4,
		"speed": 2, # To balance the game, speed is set 2 instead of 4
		"mate_time": 0.5, # To balance the game okay, mate_time is 0.5 instead of 0.1
		"scale": 1,
		"surname": player.display_name[0],
		"toward_mob": 1,
		"toward_friend": 1,
	}
	
	return player
	
func add_friend(spawn_position, gene={}):
	# Spawn friend
	print("Friend!")
	var friend = Friend.instance()
	add_child(friend)
	
	friend.position = spawn_position
	
	friend.gene = gene
	friend.set_attrs()
	print("Gene:", friend.gene) # After set_attrs, friend.gene is changed
	
	print("ShootWaitTime:", friend.get_node("BulletShooter/BulletShooterTimer").wait_time)
	print("SensorRange:", friend.get_node("Sensor").scale)
	print("Speed:", friend.get_node("RandomWalker").speed)
	print("HP:", friend.get_node("FriendBody/BodyFeature").hp)
	print("MateTime:", friend.get_node("FriendBody/MateFeature/MateTimer").wait_time)
	print("TowardMob:", friend.get_node("RandomWalker").toward_mob)
	print("TowardFriend:", friend.get_node("RandomWalker").toward_friend)
	print()
	
	unit_count += 1
	
func add_mob(spawn_position):
	# Spawn mob
	print("Mob!")
	var mob = Mob.instance()
	add_child(mob)
	
	mob.position = spawn_position
	
	var mob_attrs = $Utils.generate_mob_attrs(score, 0.5 + 0.01*spawn_count) # Adjust the difficulty here
	print("Attrs:", mob_attrs)
	mob.set_attrs(mob_attrs)
	
	# Big mob to reduce slag
	if (spawn_count > 20 and randf() < spawn_count / 100) or unit_count>50:
		print("Big Mob!")
		mob.scale *= 2
		mob.get_node("RandomWalker").speed /= 2 # It should be slower
		mob.get_node("MobBody/BodyFeature").hp *= 5 * pow((unit_count/50),2)
		mob.get_node("BulletShooter/BulletShooterTimer").wait_time /= 5 * pow((unit_count/50),2)
	
	print("ShootWaitTime:", mob.get_node("BulletShooter/BulletShooterTimer").wait_time)
	print("SensorRange:", mob.get_node("Sensor").scale)
	print("Speed:", mob.get_node("RandomWalker").speed)
	print("HP:", mob.get_node("MobBody/BodyFeature").hp)
	print()
	
	unit_count += 1

	

func get_spawn_position():
	var direction = randf()
	
	if direction < 0.5:
		return Vector2(0, rand_range(0, screensize.y))
	else:
		return Vector2(rand_range(0, screensize.x), 0)
	

func gameplay():
	# Game is cleared by Main scene
	
	# Add the player
	Player = add_player()
	
	score = 0 # DEBUG: change this
	spawn_count = 0
	unit_count = 0
	
	$SpawnTimer.start()
	$Message.show_message("目标: 获得100分！", 2)
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	$FPS.text = str(Performance.get_monitor(0))
	$Units.text = str(unit_count)
	
	# Check Win
	if score >= 100:
		# TODO: show win message
		get_tree().paused = true

func _on_Bullet_shooted(shooter, shoot_obj, direction):
	var b = Bullet.instance()
	add_child(b)
	b.shooter = shooter
	b.shoot_obj = shoot_obj
	b.position = shooter.position
	b.rotation = direction
	if "Mob" in b.shooter.name:
		b.get_node("ColorRect").color = Color(1.0, 0.5, 0.5)
	
func _on_entity_dead(entity):
	#print(entity, entity.name)
	if entity == Player:
		get_tree().paused = true
		# TODO: HUD.show_game_over
	unit_count -= 1
		
func new_friend(pos, gene):
	# This is reacting to signal
	
	var delta_score = 1
	
	score += delta_score
	$AddScore.show_message("+"+str(delta_score), 1)
	$Score.text = str(score) # Update the score HUD
	
	add_friend(pos, gene)

func _on_SpawnTimer_timeout():
	var spawn_position = get_spawn_position()
	var spawn_type = randf()
	
	# Change the conditions in "if" for adjusting friend spawning
	if (spawn_type < 0.1 or spawn_count == 3) and spawn_count != 0:
		add_friend(spawn_position)
	else:
		add_mob(spawn_position)
		
	spawn_count += 1
		
	$SpawnTimer.wait_time = rand_range(1, 5) # DEBUG: change this