extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var friends_sensed = []
var mobs_sensed = []
var prior_object
var parent
var sort_objects = false
var sorter

class SensedArrSorter:
	var player
	
	func _init(player):
		self.player = player
		
	func sort(a, b):
		if self.player.position.distance_to(a.position) < self.player.position.distance_to(b.position):
			return true # comparing distances
		else:
			return false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	parent = get_parent()
	sorter = SensedArrSorter.new(parent)


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if sort_objects:
		mobs_sensed.sort_custom(sorter, "sort")
		friends_sensed.sort_custom(sorter, "sort")

func _on_Sensor_area_entered(area):
	var entity = area.get_parent()
	if "Body" in area.name: # Sense body only
		if "Mob" in entity.name:
			mobs_sensed.append(entity)
		elif "Friend" in entity.name and entity != parent:
			friends_sensed.append(entity)


func _on_Sensor_area_exited(area):
	var entity = area.get_parent()
	if "Mob" in entity.name and entity in mobs_sensed:
		mobs_sensed.erase(entity)
	elif "Friend" in entity.name and entity in friends_sensed:
		friends_sensed.erase(entity)	
	
