extends AudioStreamPlayer

var music = [
	preload("res://assets/music/covert_operations.mp3"),
	preload("res://assets/music/determination.mp3"),
	preload("res://assets/music/inspiration.mp3")
]

func _ready():
	stream = music[randi()%music.size()]
	play()
	
func _on_AudioStreamPlayer_finished():
	stream = music[randi()%music.size()]
	play()


func _process(_delta):
	if Input.is_action_just_pressed("screenshot"):
		var img = get_viewport().get_texture().get_data()
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		img.flip_y()
		img.save_png("screenshot.png")
		
