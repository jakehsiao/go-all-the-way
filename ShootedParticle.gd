extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal finish_emitting

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func emit_once():
	if $ParticleTimer.is_stopped():
		emitting = true
		$ParticleTimer.start()


func _on_ParticleTimer_timeout():
	emitting = false
	emit_signal("finish_emitting")