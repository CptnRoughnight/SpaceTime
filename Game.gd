extends Node2D



func _ready():
	var refresh_rate = OS.get_screen_refresh_rate()
	if refresh_rate<0:
		refresh_rate=60
	Engine.iterations_per_second = refresh_rate

	Globals.viewport_container = $ViewportContainer
	Globals.viewport = $ViewportContainer/Viewport

