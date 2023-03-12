extends Camera2D

export(NodePath) onready var player = get_node(player)


var cam_zoom_speed = 0.01

var cam_max_zoom = 1.0
var cam_min_zoom = 0.4


var mousezoom : bool = false

var game_size := Vector2(960,540)
onready var window_scale : float = (OS.window_size / game_size).x
onready var actual_cam_pos := global_position

onready var hpBar = $Health
onready var hpAnim = $HPAnim
onready var PfeilContainer = $PfeilContainer
onready var deadScreen = $YouAreDead
onready var doneScreen = $Done

onready var tesseract1 = $CanvasLayer/HBoxContainer/HBoxContainer2/Tesseract1
onready var tesseract2 = $CanvasLayer/HBoxContainer/HBoxContainer2/Tesseract2
onready var tesseract3 = $CanvasLayer/HBoxContainer/HBoxContainer2/Tesseract3
onready var tesseract4 = $CanvasLayer/HBoxContainer/HBoxContainer2/Tesseract4


var tessSprite = preload("res://assets/ships/tesseract.png")

var pfeilScene = preload("res://ui/Pfeil.tscn")

var player_hp = 100

var collected = 0

func _ready():
	deadScreen.visible = false
	doneScreen.visible = false
	player.connect("SpeedChanged",self,"_on_player_SpeedChanged")
	player.connect("healthChanged",self,"_on_player_HealthChanged")
	
	
func _process(delta):
	var cam_pos = player.global_position
	
	actual_cam_pos = lerp(actual_cam_pos,cam_pos,delta*8)
	
#	var subpixel_position = actual_cam_pos.round() - actual_cam_pos
	
	#Globals.viewport_container.material.set_shader_param("cam_offset",subpixel_position)
	
	global_position = actual_cam_pos.round()
	
	#var v = Vector2(player.speed,player.speed).normalized()
	
#	if Input.is_action_just_released("debug_zoom_out"):
#		zoom *= 1.2
#		mousezoom = true
#
#	if Input.is_action_just_released("debug_zoom_in"):
#		zoom /= 1.2
#		mousezoom = true
	
	if (player_hp<100):
		var z = ((player_hp / 50.0) + 4) * zoom.x
		var c = 1.0 - (1.0/player_hp+0.001)
		hpBar.scale = Vector2(z,z) 
		hpBar.modulate = Color(1,1,1,c)
	else:
		hpBar.scale = Vector2(6,6) * zoom.x
		
		 
	if (player_hp<90):
		if (hpAnim.current_animation!="die" || hpAnim.is_playing()==false):
			hpAnim.play("die")
	else:
		hpAnim.stop()
	
	
	
func _physics_process(_delta):
	checkPfeile()
	
	
func _on_player_SpeedChanged(value):
	#if mousezoom:
	#ä	return 
		
	if value==1:
		zoom.x = lerp(zoom.x,cam_max_zoom,cam_zoom_speed)
		zoom.y = lerp(zoom.y,cam_max_zoom,cam_zoom_speed)
	else:
		zoom.x = lerp(zoom.x,cam_min_zoom,cam_zoom_speed)
		zoom.y = lerp(zoom.y,cam_min_zoom,cam_zoom_speed)
	

func _on_player_HealthChanged(value):
	player_hp = value
	

func checkPfeile():
	for n in PfeilContainer.get_children():
		n.queue_free()
		
	if Globals.PointsOfInterest.size()<=0:
		if PfeilContainer.get_child_count()>0:
			# erstmal frei machen
			for n in PfeilContainer.get_children():
				n.queue_free()
			
		return
	else:
		# erstmal frei machen
		for n in PfeilContainer.get_children():
			n.queue_free()
			
		for p in Globals.PointsOfInterest:
			if p.get_ref():
				var k = p.get_ref()
				var pfeil = pfeilScene.instance()
				PfeilContainer.add_child(pfeil)
			
				var a = global_position.direction_to(k.global_position).angle()
			
				pfeil.rotate(a)
				pfeil.translate(Vector2(1,0).rotated(a)*240)
			
			
func playerIsDead():
	deadScreen.visible = true
			

func playerIsDone():
	doneScreen.visible = true


func collect():
	match collected:
		0:
			tesseract1.texture = tessSprite
		1:
			tesseract2.texture = tessSprite
		2:
			tesseract3.texture = tessSprite
		3:
			tesseract4.texture = tessSprite
	collected += 1
