extends Control



func _on_NewGame_pressed():
	Globals.start()
	var _res = get_tree().change_scene("res://Game.tscn")


func _on_Credits_pressed():
	var _res = get_tree().change_scene("res://mainmenu/CreditsScene.tscn")



func _on_Beenden_pressed():
	get_tree().quit()


func _on_How_To_Play_pressed():
	var _res = get_tree().change_scene("res://mainmenu/HowToPlay.tscn")
