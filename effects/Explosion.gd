extends Node2D

signal done()

func _ready():
	$AnimationPlayer.play("explode")
	
	
func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("done")
	queue_free()

func _set_scale(_scale):
	scale = Vector2(_scale,_scale)
