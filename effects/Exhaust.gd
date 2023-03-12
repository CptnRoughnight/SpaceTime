extends Particles2D

onready var anim = $AnimationPlayer

var hasStarted = false

func start():
	if !hasStarted:
		anim.play("accelerate")
		hasStarted = true
	
	
func stop():
	if hasStarted:
		hasStarted = false
		anim.play_backwards("accelerate")
