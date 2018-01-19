
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var name

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	move(Vector2(0,30).rotated(get_rot()))
	if get_node("Timer").get_time_left() <= 0:
		queue_free()


func _on_Area2D_body_enter( body ):
	if body.get_name() == "Collision":
			queue_free()
	pass # replace with function body
