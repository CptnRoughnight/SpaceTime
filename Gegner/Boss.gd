extends Gegner

var tesseract = preload("res://effects/Tesseract.tscn")

var tesseractContainer = null

onready var additionalCannons = $Cannons

func _ready():
	hp = 55*8				# 55 per shot
	shotTimer=0
	imDead=false
	playerToFar = 1200

func _on_HitBox_area_entered(area):
	if imDead:
		return
	anim.play("blink")
	audio.play()
	hp -= 55
	area.queue_free()		# bullet entfernen
	
	if (hp<=0):
		imDead = true
		var ex = explosion.instance()
		ex.global_position = global_position
		ex._set_scale(4)
		get_parent().add_child(ex)
		ex.connect("done",self,"_explosion_done")
		explSound.stream = expSoundFiles[randi()%expSoundFiles.size()]
		explSound.play()
		
		
		if (tesseractContainer!=null):
			var t = tesseract.instance()
			tesseractContainer.call_deferred("add_child",t)
			t.global_position = global_position
			t.schnips()
		
	
# überschreiben
func fire_to_player(_delta):
	if global_position.distance_to(player.global_position)<500:
		
		shotTimer-=_delta
		if shotTimer<=0:
			var shotlifetime = 0.7
			lazor.play()
			var b = bulletScene.instance()
			b.lifetime = shotlifetime
			get_parent().add_child(b)
			b.global_position = cannonPosition.global_position
			b.rotate(global_position.direction_to(player.global_position).angle())
			shotTimer = shot_delay
			
			for ac in additionalCannons.get_children():
				lazor.play()
				var b2 = bulletScene.instance()
				get_parent().add_child(b2)
				b2.lifetime = shotlifetime
				b2.global_position = ac.global_position
				b2.rotate(global_position.direction_to(player.global_position).angle())
				shotTimer = shot_delay
		
		
func setTesseractContainer(v):
	tesseractContainer= v

func _explosion_done():
	._explosion_done()		# parent class
	
	for _k in range(1+randi()%2):
		var health = healtscene.instance()
		get_parent().add_child(health)
		health.global_position = global_position
	
	
