extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var body
var entity

var mating
var mate_obj
var sperm = false # Change this name?
var sperm_gene = {}

var mate_list

signal new_friend(pos, gene)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#$CollisionShape2D.shape = get_node("../Character/CollisionShape2D").shape
	
	var game = get_parent().get_parent().get_parent()
	connect("new_friend", game, "new_friend")
	
	body = get_parent()
	entity = body.get_parent()
	
	mate_list = []

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass

func start_mating(obj):
	mate_obj = obj
	mating = true
#	$MateParticle.emitting = true
	
	# Fix 'mate object not found' bug(maybe)
	if $MateTimer.wait_time < 1/30:
		$MateTimer.wait_time = 1/30
	
#	$MateTimer.start()
	$ReadyTimer.start()

func stop_mating():
	mate_obj = null
	mating = false
	sperm = false
	$MateParticle.emitting = false
	$ReadyTimer.stop()
	$MateTimer.stop()
	
	
	
	# Feature: fix the not mating bug, but cause another bug
	# Note: For not mating bug, I don't need to fix it now, fix it when --=some good methods about it come out
#	if mate_list.size() > 0:
#		var new_mater = mate_list[0]
#		if !new_mater.mating:
#			start_mating(new_mater)
#			new_mater.start_mating(self)


func _on_MateBody_area_entered(area):
	var entity2 = area.get_parent()
	
	if "FriendBody" in area.name and entity2 != entity:
		var mater = area.get_node("MateFeature")
		mate_list.append(mater)
		
		if (!mating and !mater.mating) or mater.mate_obj == self:
			start_mating(mater)
		
func _on_MateBody_area_exited(area):
	var entity2 = area.get_parent()
	
	if "FriendBody" in area.name and entity2 != entity:
		var mater = entity2.get_node("FriendBody/MateFeature")
		mate_list.erase(mater)
		
		if mate_obj == mater:
			stop_mating()
			# Feature 3.0: Mate with other guys in mate_list
			if mate_list.size() > 0:
				for i in range(mate_list.size()):
					var new_mater = mate_list[i]
					if (!mating and !new_mater.mating) or new_mater.mate_obj == self:
						start_mating(new_mater)
						return


#func start_mating(obj):
#	mate_obj = obj
#	mating = true
#	$MateParticle.emitting = true
#	$MateTimer.start()
#
#func stop_mating():
#	mate_obj = null
#	mating = false
#	sperm = false
#	$MateParticle.emitting = false
#	$MateTimer.stop()
#
#
#func _on_MateBody_area_entered(area):
#	var entity2 = area.get_parent()
#	if "FriendBody" in area.name and entity2 != entity and !mating:
#		var mater = area.get_node("MateFeature")
#		if !mater.mating or mater.mate_obj == self:
#			start_mating(mater)
#
#func _on_MateBody_area_exited(area):
#	var entity2 = area.get_parent()
#	if "FriendBody" in area.name and mating:
#		if mate_obj == entity2.get_node("FriendBody/MateFeature"):
#			stop_mating()
	
func combine_gene(gene1, gene2):
	var new_gene = {}
	print("Gene1:", gene1)
	print("Gene2:", gene2)
	var g1_keys = gene1.keys()
	var g2_keys = gene2.keys()
	for attr in g1_keys:
		if attr in g2_keys:
			if attr == "surname":
				# Set name property
				new_gene[attr] = gene2[attr]
			else:
				# Set numeric property
				new_gene[attr] = (gene1[attr] + gene2[attr])/2
			
	mutation(new_gene)
		
	print("New:", new_gene)
	return new_gene
	
func mutation(new_gene):
	# Mutation
	if randf() < 0.1:
		print("Mutation!")
		var ng_keys = new_gene.keys()
		var mutation_attr = ng_keys[randi() % ng_keys.size()]
		print(mutation_attr)
		
		if mutation_attr in ["surname"]:
			# Not number properties
			print("Mutuation failed")
		else:
			if randf() > 0.5:
				new_gene[mutation_attr] *= 2
			else:
				new_gene[mutation_attr] *= 0.5
		

func _on_MateTimer_timeout():
	if sperm:
		var new_gene = combine_gene(entity.gene, sperm_gene)
		emit_signal("new_friend", entity.position, new_gene)
		sperm = false
		
	else:
		mate_obj.sperm = true
		mate_obj.sperm_gene = entity.gene

func _on_ReadyTimer_timeout():
	$MateTimer.start()
	$MateParticle.emitting = true