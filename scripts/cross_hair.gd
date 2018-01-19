
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	Input.set_mouse_mode(1)
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	set_pos(get_global_mouse_pos())

