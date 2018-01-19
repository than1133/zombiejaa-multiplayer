extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player_list = []
sync var player = []


func _ready():
	get_tree().connect("connected_to_server", self, "_connection_ok")
	pass
	
func _on_host_pressed():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(25380, 3)
	get_tree().set_network_peer(host)
	player_list.append("player"+str(player_list.size()))
	print(str(player_list.size()))
	rset("player", player_list)
	rpc("add_player")

func _on_join_pressed():
	var host = NetworkedMultiplayerENet.new()
	host.create_client("127.0.0.1", 25380)
	get_tree().set_network_peer(host)
	pass # replace with function body

func _connection_ok():
	print("connection_ok")
	print(str(player.size()))
	player_list.append("player"+str(player_list.size()))
	rset("player", player_list)
	rpc("add_player")
	pass
	
remote func add_player():
	get_node("ItemList").add_item("player")
