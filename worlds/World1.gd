extends Node2D

const num_stars = 20
const num_planets = 3
const num_asteroids = 15

const size = 1000
const blackhole_size = 400
const gegner_range = 1600
const gegner_range_near = 1200

const tesseract_near = 1000
const tesseract_far = 2000

const boss_position = 3000
const boss_position_near = 1200

onready var backgroundLayer = $ParallaxBackground/Background
onready var StarsLayer = $ParallaxBackground/Stars
onready var PlanetsLayer = $ParallaxBackground/Planets
onready var MeteorsLayer = $ParallaxBackground/Meteors
onready var blackHoleLayer = $BlackHole
onready var supermassiveblackhole = $ParallaxBackground/Background/supermassiveblackhole

onready var sunViewport = $SunViewport
onready var sunSprite = $ParallaxBackground/Transition/SunSprite

onready var gegnerContainer = $Gegner

onready var animation = $AnimationPlayer

onready var player = $Player

onready var tesseractContainer = $Tesseracts

onready var cam = $MainCamera

onready var deadKeyTimer = $DeadKeyTimer

onready var spawnTimer = $SpawnTimer

var isPlayerDead = false


var blackholeScene = preload("res://blackhole/blackhole.tscn")
var sunScene = preload("res://sun/Sun3d.tscn")
var staubScene = preload("res://staubwolke/Staubwolke.tscn")


var starImage = preload("res://assets/stars/star_small.png")
var m1 = preload("res://assets/meteors/m1.png")
var m2 = preload("res://assets/meteors/m2.png")
var m3 = preload("res://assets/meteors/m3.png")

var pl1 = preload("res://assets/planets/pl1.png")
var pl2 = preload("res://assets/planets/pl2.png")
var pl3 = preload("res://assets/planets/pl36.png")

var gegnerscene = preload("res://Gegner/Gegner.tscn")
var bossscene = preload("res://Gegner/Boss.tscn")

var tesseractScene = preload("res://effects/Tesseract.tscn")

func _ready():
	deadKeyTimer.one_shot = true
	
	changeTimePeriod()
	initObjects()
	
	player.connect("InBlackHole",self,"_player_is_in_blackhole")
	player.connect("ImDead",self,"_on_player_died");
	player.connect("TesseractsCollected",self,"_on_player_is_done")
	player.connect("collected",self,'_on_player_collected')
	
	randomize()
	
	var blackHole = blackholeScene.instance()
	blackHoleLayer.add_child(blackHole)
	#blackHole.global_position = Vector2(-blackhole_size+randi()%blackhole_size*2,-blackhole_size+randi()%blackhole_size*2)
	blackHole.global_position = Globals.getRandomPoint(blackhole_size/2.0,blackhole_size)
	blackHole.scale = Vector2(0.4,0.4)	
	blackHole.activate()
	Globals.PointsOfInterest.append(weakref(blackHole))
	
	
func _input(event):
	if isPlayerDead:
		if event is InputEventKey && deadKeyTimer.time_left<=0:
			var _res = get_tree().change_scene("res://mainmenu/MainMenu.tscn")


func _process(_delta):
	#if Globals.currentTimePeriod==Globals.TIMEPERIOD.STEINZEIT:
	var tex = sunViewport.get_texture()
	sunSprite.texture = tex


func _player_is_in_blackhole():
	animation.play("FadeIn")
	



func changeTimePeriod():
	for n in sunViewport.get_children():
		n.queue_free()
		
	for n in supermassiveblackhole.get_children():
		n.queue_free()
		
		
	if Globals.currentTimePeriod==Globals.TIMEPERIOD.STEINZEIT:
		spawnTimer.wait_time = 4
		for n in MeteorsLayer.get_children():
			n.queue_free()
		for n in StarsLayer.get_children():
			n.queue_free()
		for n in PlanetsLayer.get_children():
			n.queue_free()
			
		var staub = staubScene.instance()
		sunViewport.add_child(staub)
		sunSprite.visible=true
		spawnGegner()
		spawnTesseract()
		
	if Globals.currentTimePeriod==Globals.TIMEPERIOD.NORMAL:
		spawnTimer.wait_time = 4
		initObjects()
		var sun = sunScene.instance()
		sunViewport.add_child(sun)
		sun.normalSun()
		sunSprite.visible=true
		
	if Globals.currentTimePeriod==Globals.TIMEPERIOD.ROTERRIESE:
		spawnTimer.wait_time = 6
		initObjects()
		var sun = sunScene.instance()
		sunViewport.add_child(sun)
		sun.roterRiese()
		sunSprite.visible=true
		
	if Globals.currentTimePeriod==Globals.TIMEPERIOD.BLACKHOLE:
		spawnTimer.wait_time = 6
		initObjects()
		var sun = blackholeScene.instance()
		supermassiveblackhole.add_child(sun)
		sunSprite.visible=false
		sun.deactivate()
		


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		# random new time era
		var newtime = randi()%4
	
		Globals.currentTimePeriod=Globals.TIMEPERIOD.get(Globals.TIMEPERIOD.keys()[newtime])
	
		player.reset()
		
		for i in blackHoleLayer.get_children():
			i.queue_free()
			
		Globals.PointsOfInterest.clear()
		var blackHole = blackholeScene.instance()
		blackHoleLayer.add_child(blackHole)
		#blackHole.global_position = Vector2(-blackhole_size+randi()%blackhole_size*2,-blackhole_size+randi()%blackhole_size*2)
		blackHole.global_position = Globals.getRandomPoint(blackhole_size/2.0,blackhole_size)
		blackHole.scale = Vector2(0.4,0.4)	
		blackHole.activate()
		
		Globals.PointsOfInterest.append(weakref(blackHole))
		
		changeTimePeriod()
		
		animation.play("FadeOut")
	
	
func initObjects():
	for n in MeteorsLayer.get_children():
		n.queue_free()
	for n in StarsLayer.get_children():
		n.queue_free()
	for n in PlanetsLayer.get_children():
		n.queue_free()
			
	for _i in range(num_stars):
		var siInstance = Sprite.new()
		siInstance.texture = starImage
		var s = rand_range(0.2,0.7)
		siInstance.transform = siInstance.transform.scaled(Vector2(s,s))
		StarsLayer.add_child(siInstance)
		#siInstance.global_position = Vector2(-size+randi()%size*2,-size+randi()%size*2)
		siInstance.global_position = Globals.getRandomPoint(size/2.0,size)
		
	for _j in range(0,3):
		var siInstance = Sprite.new()
		var i = randi()%3
		match i:
			0:				
				siInstance.texture = pl1
			1:
				siInstance.texture = pl2
			2:
				siInstance.texture = pl3
			
		var s = rand_range(0.2,0.7)
		siInstance.transform = siInstance.transform.scaled(Vector2(s,s))
		PlanetsLayer.add_child(siInstance)
		#siInstance.global_position = Vector2(-size+randi()%size*2,-size+randi()%size*2)
		siInstance.global_position = Globals.getRandomPoint(size/2.0,size)
		
	for _k in range(0,num_asteroids):
		var siInstance = Sprite.new()
		var i = randi()%3
		match i:
			0:				
				siInstance.texture = m1
			1:
				siInstance.texture = m2
			2:
				siInstance.texture = m3
		var s = rand_range(0.2,0.7)
		siInstance.transform = siInstance.transform.scaled(Vector2(s,s))
		MeteorsLayer.add_child(siInstance)
		#siInstance.global_position = Vector2(-size+randi()%size*2,-size+randi()%size*2)
		siInstance.global_position = Globals.getRandomPoint(size/2.0,size)
		
	spawnGegner()
	spawnTesseract()



func spawnGegner():
	for n in gegnerContainer.get_children():
		n.queue_free()
		
	var num 
	match Globals.currentTimePeriod:
		Globals.TIMEPERIOD.STEINZEIT:
			num = Globals.numGegnerPerTimePeriod[0]
		Globals.TIMEPERIOD.NORMAL:
			num = Globals.numGegnerPerTimePeriod[1]
		Globals.TIMEPERIOD.ROTERRIESE:
			num = Globals.numGegnerPerTimePeriod[2]
		Globals.TIMEPERIOD.BLACKHOLE:
			num = Globals.numGegnerPerTimePeriod[3]
			
	for _i in range(num):
		var gi = gegnerscene.instance()
		gegnerContainer.add_child(gi)
		#gi.global_position = Vector2(-gegner_range/2.0+randi()%gegner_range+150,-gegner_range/2.0+randi()%gegner_range+150)
		gi.global_position = Globals.getRandomPoint(gegner_range_near,gegner_range)
		

func spawnTesseract():
	
	
	for n in tesseractContainer.get_children():
		n.queue_free()
	
		
	# ist schon geholt worden?
	# TODO: check if 3 are collected -> ENDGAME!!!
	
	if Globals.collectedTesseract[Globals.currentTimePeriod]!=null:
		return
		
		
		
	var n = -1
	
	match Globals.currentTimePeriod:
		Globals.TIMEPERIOD.STEINZEIT:
			n=0
		Globals.TIMEPERIOD.NORMAL:
			n=1
		Globals.TIMEPERIOD.ROTERRIESE:
			n=2
		Globals.TIMEPERIOD.BLACKHOLE:
			n=3
	
	if (n!=-1):
		#if Globals.tesseractPosition[n] == null:
		if n==0 || n==3:
			# add boss
			var b = bossscene.instance()
			gegnerContainer.add_child(b)
			#b.global_position = Vector2(boss_position/2.0+randi()%boss_position,boss_position/2.0+randi()%boss_position)
			b.global_position = Globals.getRandomPoint(boss_position_near,boss_position)
			b.setTesseractContainer(tesseractContainer)
			Globals.PointsOfInterest.append(weakref(b))
			
			
			
		if Globals.tesseractPosition[n] == Vector2(0,0):
			# add tesseract
			
			
			# random position
			var r = 0
			if Globals.currentTimePeriod == Globals.TIMEPERIOD.NORMAL:
				r = tesseract_near
			elif Globals.currentTimePeriod == Globals.TIMEPERIOD.ROTERRIESE:
				r = tesseract_far
				
			var t = tesseractScene.instance()
			tesseractContainer.add_child(t)
			#t.global_position = Vector2(r/2.0+randi()%r,r/2.0+randi()%r)
			t.global_position = Globals.getRandomPoint(r,r*1.5)
			
	

func _on_player_died():
	deadKeyTimer.start(3)	
	cam.playerIsDead()
	isPlayerDead=true

func _on_player_is_done():
	deadKeyTimer.start(3)	
	cam.playerIsDone()
	isPlayerDead=true

func _on_player_collected():
	cam.collect()


func _on_SpawnTimer_timeout():
	var gi = gegnerscene.instance()
	gegnerContainer.add_child(gi)
	gi.global_position = Globals.getRandomPoint(gegner_range_near,gegner_range)
