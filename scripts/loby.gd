
extends Control

# member variables here, example:
# var a=2
# var b="textvar"
var connect
var player

func _ready():
	connect = get_node("connection")
	player = get_node("player")
	
	gamestate.connect("connection_failed",self,"_on_connection_failed")
	gamestate.connect("connection_succeeded",self,"_on_connection_success")
	gamestate.connect("player_list_changed",self,"refresh_lobby")
	gamestate.connect("game_ended",self,"_on_game_ended")
	gamestate.connect("game_error",self,"_on_game_error")

	
func _on_connection_success():
	get_node("connection").hide()
	get_node("player").show()

func _on_host_btn_pressed():
	connect.hide()
	player.show()
	gamestate.host_game(get_node("connection/player_name").get_text())
	refresh_lobby()


func _on_join_pressed():
	var host = NetworkedMultiplayerENet.new()
	var ip = get_node("connection/ip").get_text()
	
	if not ip.is_valid_ip_address():
		get_node("connection/error_label").set_text("Invalid IPv4 Address")
		return
	gamestate.join_game(ip, get_node("connection/player_name").get_text()) 
	refresh_lobby()
	
func refresh_lobby():
	var players = gamestate.get_player_list()
	get_node("player/list").clear()
	players.sort()
	get_node("player/list").add_item(gamestate.get_player_name()+" (You)")
	for p in players:
		print(p)
		get_node("player/list").add_item(p)
		
	get_node("player/start").set_disabled(not get_tree().is_network_server())
	
func _on_start_pressed():
	gamestate.begin_game()
	pass
