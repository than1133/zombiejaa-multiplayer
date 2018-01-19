
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var count = 3
onready var i = 0 
var zomdead = {}


func _ready():
	zomdead[0] = false
	zomdead[1] = false
	zomdead[2] = false
	get_node("Timer").start()
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if is_network_master():
		if i <= count:
			if get_node("Timer").get_time_left() <= 0:
				rpc("zom", i)
				zomdead[i+1] = true
				i+=1
				get_node("Timer").stop()
				get_node("Timer").set_wait_time(1.5)
				get_node("Timer").start()
		if zomdead[0] == false and zomdead[1] == false and zomdead[2] == false:
			i = 0

func zom_dead1():
	zomdead[0] = false
func zom_dead2():
	zomdead[1] = false
func zom_dead3():
	zomdead[2] = false

sync func zom(i):
	if i == 0:
		var zomm = preload("res://instance/Enemy.tscn").instance()
		add_child(zomm)
	elif i == 1:
		var zomm = preload("res://instance/Enemy2.tscn").instance()
		add_child(zomm)
	elif i == 2:
		var zomm = preload("res://instance/Enemy3.tscn").instance()
		add_child(zomm)

