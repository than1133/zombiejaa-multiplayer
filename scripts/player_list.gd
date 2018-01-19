extends Node2D

var player_listing = {}
var sprite = ["res://picture/awewe0000.tex",
              "res://picture/act01.tex",
              "res://picture/act02.tex",
              "res://picture/act03.tex",
              "res://picture/act04.tex",
              "res://picture/die.tex",
              ]
var you_win
sync var player_count=0

func _ready():
	you_win = get_node("CanvasLayer/gui_all/you_win")
	you_win.hide()
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	if player_count == 1:
		you_win.show()
	get_node("CanvasLayer/gui_all/fps").set_text("FPS : " + str(OS.get_frames_per_second()))
	
sync func add_kill_list(who, kill, died):
	var kill_con = load("res://instance/kill__list_content.tscn").instance()
	kill_con.set_string_in(who, kill, died)
	get_node("CanvasLayer/gui_all/kill_list").add_child(kill_con)
	
func add_player_list(id, name):
	player_count+=1
	var player_list = load("res://instance/player_list.tscn").instance()
	player_list.get_node("pic").set_texture(load(sprite[id]))
	player_list.get_node("pic").set_scale(Vector2(0.5, 0.5))
	player_list.get_node("name").set_text(name)
	get_node("CanvasLayer/gui_all/player_list").add_child(player_list)
	
sync func player_dead(id):
	player_count-=1
	var p = get_node("CanvasLayer/gui_all/player_list").get_child(id)
	p.get_child(0).set_texture(load(sprite[5]))
