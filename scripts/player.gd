
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var id
var timing
var gun_sound
onready var live = 100
slave var slave_live = 100
slave var slave_mag = 50
var mag = 50
var player
var kill_by

slave var slave_rot
slave var slave_pos = Vector2()

func _ready():
	rset("slave_rot", 0)
	player = get_node("Sprite")
	get_node("bgm").play(0)
	gun_sound = get_node("gun")
	timing = get_node("Timer")
	set_fixed_process(true)
	
	pass

func _fixed_process(delta):
	if get_parent().get_parent().player_count==1 :
		live = 100
	if is_network_master() :
		if live > 0:
			get_node("cl/GUI").show()
			blood_timer()
			get_node("Camera2D").make_current()
			if Input.is_action_pressed("w"):
				move(Vector2(0, -5))
			if Input.is_action_pressed("a"):
				move(Vector2(-5, 0))
			if Input.is_action_pressed("s"):
				move(Vector2(0, 5))
			if Input.is_action_pressed("d"):
				move(Vector2(5, 0))
			player.look_at(get_global_mouse_pos())
			rset("slave_rot", player.get_rot())
			rset("slave_pos", get_pos())
			
			if mag > 0:
				if Input.is_action_pressed("shoot"):
					
					timing.set_wait_time(0.15)
					if timing.get_time_left() <= 0:
						get_node("Camera2D/AnimationPlayer").play("shoot")
						mag-=1
						rset("slave_mag", mag)
						timing.start()
						rpc("bullet", gamestate.player_name)
	
			if mag <=0:
				if Input.is_action_pressed("r"):
					timing.set_wait_time(1)
					timing.start()
					get_node("reload").play(0)
					mag=50
					rset("slave_mag", mag)
				if Input.is_action_pressed("shoot"):
					if timing.get_time_left() <= 0:
						get_node("gun_empty").play(0)
						timing.start()
		else:
			if is_in_group("player"):
				remove_from_group("player")
				live=0
				get_parent().get_parent().rpc("player_dead", id)
				rpc("change_pic_when_dead")
				get_node("cl/game_over").show()
				
				
	else:
		get_node("cl/GUI").hide()
		#print(str(is_in_group("player")))
		if live > 0:
			live = slave_live
			mag = slave_mag
			player.set_rot(slave_rot)
			set_pos(slave_pos)
			get_node("Camera2D").clear_current()
		else :
			live=0
			if is_in_group("player"):
				remove_from_group("player")
				
master func blood_timer():
	var blood_time = get_node("cl/blood_time")
	var blood = get_node("cl/blood").set_opacity(blood_time.get_time_left())
	
func damage(damage):
	get_node("cl/blood_time").start()
	live-=damage
	rset("slave_live" , live)

sync func bullet(name):
	var bullet_ins = load("res://instance/bullet.tscn").instance()
	var fire_ins = load("res://instance/gun_fire.tscn").instance()
	bullet_ins.set_pos(get_node("Sprite/Position2D").get_global_pos()-get_global_pos())
	bullet_ins.set_rot(player.get_rot())
	bullet_ins.name = name
	
	fire_ins.set_pos(get_node("Sprite/Position2D").get_global_pos()-get_global_pos())
	fire_ins.set_rot(player.get_rot())
	
	gun_sound.play(0)
	add_child(bullet_ins)
	add_child(fire_ins)

func _on_bullet_col_body_enter( body ):
	if live > 0:
		if body.is_in_group("bullet"):
			damage(8)
			rset("slave_live" , live)
			if live <= 0:
				kill_death(body.name)
			body.queue_free()

sync func change_pic_when_dead():
	player.set_rot(0)
	get_node("Sprite").set_texture(load("res://picture/die.tex"))
	
func kill_death(name):
	if is_network_master():
		get_parent().get_parent().rpc("add_kill_list" , str(name),  "ฆ่า", str(gamestate.player_name))