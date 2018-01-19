
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var hp = 5
var speed = 4.5
var attack = 10
var timer
var ray
slave var slave_pos = Vector2()
slave var slave_rot = 0
onready var target
onready var t = Vector2()
onready var dead = false

func _ready():

	ray = get_node("RayCast2D")
	get_node("RayCast2D").add_exception(self)
	set_fixed_process(true)
	timer = get_node("Timer")
	target = get_tree().get_root().get_node("map/players").get_child(0)
	pass

func _fixed_process(delta):
	if not target.is_in_group("player"):
		for p in get_tree().get_root().get_node("map/players").get_children():
			if p.is_in_group("player"):
				target = p
				break
	if is_network_master():
		if hp > 0:
			for p in get_tree().get_root().get_node("map/players").get_children():
				if p.is_in_group("player"):
					if p.get_pos().distance_to(get_pos()) < target.get_pos().distance_to(get_pos()):
						target=p
			look_at(target.get_pos())
			move(Vector2(0,speed).rotated(get_rot()))
			rset("slave_pos", get_pos())
			rset("slave_rot", get_rot())

	else:
		set_pos(slave_pos)
		set_rot(slave_rot)
		
	# Check zombie hp
	if hp <= 0:
		hide()
		get_node("CollisionShape2D").set_trigger(true)
		if dead == false:
			var zom_dead_ins = load("res://instance/zom_dead2.tscn").instance()
			zom_dead_ins.set_pos(get_pos())
			get_parent().add_child(zom_dead_ins)
			dead = true
			ray.set_enabled(false)
			#get_parent().zom_dead2()
			hide()
	# Hit player
	if ray.is_colliding() and ray.get_collider() != null:
		if ray.get_collider().is_in_group("player"):
			if timer.get_time_left() <=0:
				ray.get_collider().damage(attack)
				if ray.get_collider().live <= 0:
					ray.get_collider().kill_death("Zombie")
				timer.start()

func _on_area__hit_body_enter( body ):
	if hp > 0:
		if body.is_in_group("bullet"):
			get_node("zombie_hit").play(0)
			body.remove_from_group("bullet")
			body.hide()
			hp-=1
