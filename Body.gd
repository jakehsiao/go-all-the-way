extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var hp_heal_max = 5
var hp = 5
var body
var entity

signal dead(entity)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var game = get_parent().get_parent().get_parent()
	if game.name == "Game":
		connect("dead", game, "_on_entity_dead")
	body = get_parent()
	entity = body.get_parent()
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if hp <= 0:
		emit_signal("dead", entity)
		entity.queue_free()
		

func _on_Body_area_entered(area):
	if "Bullet" in area.name:
		var entity_shooter = area.shooter
		var entity_obj = area.shoot_obj
		#print("Bullet in", entity_shooter, entity_obj)
		if weakref(entity).get_ref() and weakref(entity_obj).get_ref():
			if entity.get("entity_type") == entity_obj.get("entity_type") and entity != entity_shooter:
				# No need to directly shoot the object, enemy is okay, just like lol!
				hp -= 1
				area.explode()
			
	if "Body" in area.name:
		# Fight
		var entity2 = area.get_parent()
		var bf2 = area.get_node("BodyFeature")
		if entity.entity_type != entity2.entity_type:
			hp -= 5 * entity2.scale.x
			bf2.hp -= 5 * entity.scale.x
		

func _on_HealTimer_timeout():
	if hp < hp_heal_max:
		hp += 1