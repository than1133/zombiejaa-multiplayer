extends Light2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	pass
	
func _fixed_process(delta):
	if get_node("Timer").get_time_left() <= 0:
		queue_free()