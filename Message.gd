extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var contents = []
var dur = 1.5
var interval = 3.5

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	hide()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func show_message(content, dur=1):
	text = content
	show()
	$ShowTimer.wait_time = dur
	$ShowTimer.start()
	
func show_list_messages(messages, dur=1.5, interval=3.5):
	contents = messages
	dur = dur
	interval = interval
	show_single_message()

func show_single_message():
	text = contents[0]
	show()
	$ShowTimer.wait_time = dur
	$ShowTimer.start()
	

func _on_ShowTimer_timeout():
	hide()
	$WaitTimer.wait_time = interval
	$WaitTimer.start()
	


func _on_WaitTimer_timeout():
	contents.pop_front()
	if contents.size() > 0:
		show_single_message()
	
	