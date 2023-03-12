extends CanvasLayer

func _ready():
	visible = false
	
	
func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused


func _on_Continue_pressed():
	get_tree().paused = false
	visible = false


func _on_Back_To_Menu_pressed():
	get_tree().paused = false
	var _res = get_tree().change_scene("res://mainmenu/MainMenu.tscn")
