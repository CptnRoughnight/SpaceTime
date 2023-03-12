extends KinematicBody2D

class_name Gegner

var speed = 120

onready var directionTimer = $DirectionTimer

onready var cannonPosition = $Cannon

onready var anim = $AnimationPlayer

onready var audio = $AudioStreamPlayer2D
onready var lazor = $Lazor
onready var explSound = $Explosions

onready var exhaust = $Exhaust


var playerToFar = 400
var expSoundFiles = [
	preload("res://assets/sounds/Explosion1.wav"),
	preload("res://assets/sounds/Explosion2.wav")
]


var bulletScene = preload("res://shots/shot.tscn")
var explosion = preload("res://effects/Explosion.tscn")
var healtscene = preload("res://items/HealthPotion.tscn")

var minDirectionTime = 5.2
var maxDirectionTime = 8.8

var direction := Vector2(1,0)
var newDirection := Vector2.ZERO
var velocity := Vector2(0,speed)

var moveToHome : bool = false
var toPlayer : bool = false

var player

var shotTimer = 0.0
var shot_delay = 1.2


var hp = 100

var imDead : bool = false


var explosion_size = 1


func _ready():
	exhaust.start()
	directionTimer.one_shot = true
	var angle = deg2rad(randi()%360)
	newDirection = Vector2.RIGHT.rotated(angle)
	directionTimer.start(rand_range(minDirectionTime,maxDirectionTime))



func _physics_process(_delta):
	if imDead:
		return
		
	if newDirection.angle()!=direction.angle():
			direction.x = lerp(direction.x,newDirection.x,8*_delta)
			direction.y = lerp(direction.y,newDirection.y,8*_delta)
			rotation_degrees = rad2deg(direction.angle())
			
	velocity = direction * speed
	var _res = move_and_slide(velocity)		
	
	if toPlayer:
		if global_position.distance_to(player.global_position)>playerToFar:
			toPlayer = false
			shotTimer = 0
		#	player=null
			directionTimer.start(rand_range(minDirectionTime,maxDirectionTime))
		else:
			newDirection = global_position.direction_to(player.global_position)
			
		fire_to_player(_delta)
		
			
			
		return	# don't go home if too far
	
	
	if !moveToHome:
		if (global_position.distance_to(Vector2(0,0))>5000):
			moveToHome = true
			# rotate towards 0,0
			newDirection = global_position.direction_to(Vector2(0,0))
			
	else:
		if (global_position.distance_to(Vector2(0,0))<50):
			moveToHome = false
			directionTimer.start(rand_range(minDirectionTime,maxDirectionTime))



	

func fire_to_player(_delta):
	if global_position.distance_to(player.global_position)<300:
			shotTimer-=_delta
			if shotTimer<=0:
				lazor.play()
				var b = bulletScene.instance()
				get_parent().add_child(b)
				b.global_position = cannonPosition.global_position
				b.rotate(global_position.direction_to(player.global_position).angle())
				shotTimer = shot_delay
				
				
func _on_DirectionTimer_timeout():
	if moveToHome:
		return
		
	var angle = deg2rad(randi()%360)

	newDirection = Vector2.RIGHT.rotated(angle)
	directionTimer.start(rand_range(minDirectionTime,maxDirectionTime))


func _on_PlayerDetect_body_entered(body):
	if body.name == "Player" && !toPlayer:
		toPlayer = true
		player = body
		newDirection = global_position.direction_to(player.global_position)
	
	
	
	
func _on_HitBox_area_entered(area):
	audio.play()
	anim.play("blink")
	hp -= 55
	area.queue_free()	# bullet entfernen
	
	if (hp<=0):
		imDead = true
		explSound.stream = expSoundFiles[randi()%expSoundFiles.size()]
		explSound.play()
		var ex = explosion.instance()
		ex.global_position = global_position
		get_parent().add_child(ex)
		ex.connect("done",self,"_explosion_done")
		
	
	area.get_parent().queue_free()	# remove bullet




func _explosion_done():
	
	var canISpawn = rand_range(0,2)
	
	if (canISpawn<1):
		var health = healtscene.instance()
		get_parent().add_child(health)
		health.global_position = global_position
		# TODO: sound effect or something
	
	
	queue_free()
