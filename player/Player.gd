extends KinematicBody2D


signal SpeedChanged(v)
signal InBlackHole()
signal healthChanged(value)
signal ImDead()
signal TesseractsCollected()
signal collected()

var direction := Vector2.UP


var velocity := Vector2.ZERO


var BoostSpeed = 300.0
var Maxspeed = 200.0
var rotSpeed = 180.0


var speed := 0.0


var target_angle : float = 0

var isInBlackHole : bool = false

var AmIDead : bool = false


onready var blackholeDetect = $BlackholeDetect
onready var cannonPosition = $Cannon

onready var hitAudio = $HitAudio
onready var lazorAudio = $Lazor
onready var powerup = $Powerup
onready var tesseractAudio = $Tesseract
onready var boostBar = $ui/TextureProgress
onready var exhaust = $Exhaust



var bullet = preload("res://shots/playerBullet.tscn")
var explosion = preload("res://effects/Explosion.tscn")



var boostvalue = 100
var boostFillTimer = 0
var boostFillDelay = 0.5



var bulletTimer = 0.0

var hp = 100

var shot_delay = 0.4


var pfeil_radius = 120


var collectedTesseracts = 0


func _ready():
	boostBar.value = 100

	
func _physics_process(_delta):
	if AmIDead:
		return
		
		
	if boostvalue<100:
		boostFillTimer-=_delta
		if boostFillTimer<=0:
			boostvalue += 0.5
			boostFillTimer = boostFillDelay
			boostBar.value = int(boostvalue)
	else:
		boostvalue = 100
			
	var input := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	)

	if input.length_squared()>0:
		rotate(deg2rad(sign(input.x)*rotSpeed*_delta))
		direction = direction.rotated(deg2rad(sign(input.x)*rotSpeed*_delta))

	if Input.is_action_pressed("forward"):
		exhaust.start()
		speed = Maxspeed
		if (Input.is_action_pressed("boost") && boostvalue>0):
			speed = BoostSpeed
			boostvalue-=0.2
			boostBar.value = int(boostvalue)
			
		
			
		emit_signal("SpeedChanged",1)
	else:
		exhaust.stop()
		speed = 0
		emit_signal("SpeedChanged",0)
	
	velocity = speed*direction
	
	
	velocity = move_and_slide(velocity)
	
	detectBlackHole()
	
	fireBullet(_delta)
	




func fireBullet(_delta):
	bulletTimer -= _delta
	if (Input.is_action_just_pressed("fire")) && bulletTimer<=0:
		bulletTimer = shot_delay
		lazorAudio.play()
		
		var b = bullet.instance()
		get_parent().add_child(b)
		b.global_position = cannonPosition.global_position
		b.rotate(direction.angle())
	
	
	pass
	
	
func detectBlackHole():
	if AmIDead:
		return
		
	var blackHoleAreas = blackholeDetect.get_overlapping_areas()
	for n in blackHoleAreas:
		if n.is_in_group("blackhole"):
			pass


func reset():
	global_position = Vector2(0,0)
	isInBlackHole=false


func _on_BlackholeDetect_body_entered(_body):
	pass
	


func _on_BlackholeDetect_area_entered(area):
	if AmIDead:
		return

	if area && isInBlackHole==false && area.is_in_group("blackhole"):
		isInBlackHole=true
		emit_signal("InBlackHole")
		
	if area && area.is_in_group("tesseract"):
		Globals.collectedTesseract[Globals.currentTimePeriod] = 1
		# clear points of interest
		tesseractAudio.play()
		
		emit_signal("collected")
		collectedTesseracts+=1
		if (collectedTesseracts==4):
			emit_signal("TesseractsCollected")
		
		for p in range(0,Globals.PointsOfInterest.size()):
			if (Globals.PointsOfInterest[p].get_ref()):
				var k = Globals.PointsOfInterest[p].get_ref()
				if k.global_position == area.get_parent().global_position:
					Globals.PointsOfInterest.erase(area.get_parent().global_position)
		area.get_parent().queue_free()
		
		
		
	if area && area.is_in_group("health"):
		area.get_parent().queue_free()			# delete this health potion
		hp += 20
		powerup.play()
		if (hp>100):
			hp=100
		emit_signal("healthChanged",hp)
		


func _on_Hitbox_area_entered(area):
	if AmIDead:
		return

	if area.is_in_group("bullets"):
		hp -= 15
		hitAudio.play()
		if (hp<=0):
			var ex = explosion.instance()
			ex.global_position = global_position
			ex.connect("done",self,"_explosion_done")
			get_parent().add_child(ex)
			AmIDead=true
			return	
		
		emit_signal("healthChanged",hp)
		area.get_parent().queue_free()


func _explosion_done():
	emit_signal("ImDead")		
