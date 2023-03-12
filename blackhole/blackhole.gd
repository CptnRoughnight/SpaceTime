extends Node2D


func deactivate():
	$DetectPlayer/CollisionShape2D.disabled=true

func activate():
	$DetectPlayer/CollisionShape2D.disabled=false
