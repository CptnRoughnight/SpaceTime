extends Sprite

class_name shot

var speed = 560

var lifetime = 0.3


func _physics_process(_delta):
	position += Vector2.UP.rotated(deg2rad(rotation_degrees))*speed*_delta
	lifetime -= _delta
	if (lifetime<=0):
		queue_free()
