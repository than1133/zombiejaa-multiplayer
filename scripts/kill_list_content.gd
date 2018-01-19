extends HBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	
	
func set_string_in(who , kill, died):
	get_node("Who").set_text(who)
	get_node("kill").set_text(kill)
	get_node("Died").set_text(died)


func _on_Timer_timeout():
	queue_free()
	pass # replace with function body
