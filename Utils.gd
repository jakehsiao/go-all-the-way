extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var n

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#print(range(1,5))
#
#	print(generate_mob_attrs(0))
#	print(generate_mob_attrs(1))
#	print(generate_mob_attrs(50))

	n = Node.new()
	print(n)
	print(has_node(n.get_path()))
	print(weakref(n).get_ref())
	n.queue_free()
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
#	print(n)
#	print(has_node(n.get_path()))
#	print(weakref(n).get_ref())

	
	pass

func sum(arr):
	var val = 0
	for i in arr:
		val += i
	return val

func norm(arr):
	var arr_sum = sum(arr)
	for i in range(arr.size()):
		arr[i] = arr[i] / arr_sum
	
func randf_arr(n):
	var rand_arr = []
	for i in range(n):
		rand_arr.append(randf())
	return rand_arr
	
func arr_add_const(arr, c):
	for i in range(arr.size()):
		arr[i] += c
		
func arr_times_const(arr, c):
	for i in range(arr.size()):
		arr[i] *= c
	
func generate_mob_attrs(score, difficulty=0.5):
	var attrs = {}
	var attr_names = ["speed", "bullet_rate", "sensor_range", "hp"]
	var attr_values = randf_arr(attr_names.size())
	norm(attr_values)
	var strength = score * difficulty + 1 # Adjust this to adjust the difficulty
	print("score:", score, " difficulty", difficulty, " strength", strength)
	arr_times_const(attr_values, strength * attr_names.size())
	for i in range(attr_names.size()):
		attrs[attr_names[i]] = attr_values[i]
	return attrs