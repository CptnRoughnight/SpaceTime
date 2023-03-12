extends Sprite

# bekommt die Position bei erstellung..
# random direction
# random speed
# random zeit
# erst danach collision aktiviern

var lifetime = 0
var direction
var speed

func _ready():
	Globals.PointsOfInterest.append(weakref(self))


func _physics_process(delta):
	lifetime-=delta
	if (lifetime>0):
		global_position = global_position + direction*speed*delta



func schnips():
	print("schnips")
	direction = Vector2(randf(),randf()).normalized()
	speed = rand_range(600,800)
	lifetime = rand_range(1.2,3)

	
