
extends Control

# member variables here, example:
# var a=2
# var b="textvar"
var live
var mag
var live_label
var mag_label
var live_bar

func _ready():
	live_bar = get_node("livebar")
	live_label = get_node("Live")
	mag_label = get_node("Magazine")
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	live = get_parent().get_parent().live
	mag = get_parent().get_parent().mag
	live_label.set_text("HP :              "+str(live)+"/100")
	mag_label.set_text("Magezine : "+str(mag)+"/50")
	live_bar.set_value(live)

func set_player_name(name):
	get_node("Name").set_text(name)