extends Control

onready var sunSprite = $ParallaxBackground/Background/SunSprite
onready var staubView = $SunViewport



func _process(_delta):
	sunSprite.texture = staubView.get_texture()


func _on_Button_pressed():
	var _res = get_tree().change_scene("res://mainmenu/MainMenu.tscn")

