tool
extends Spatial

onready var multimesh = $MultiMeshInstance

var instances = 2000

var instColor = Color(0.36,0.29,0.17,1)

func _ready():
	multimesh.multimesh = MultiMesh.new()
	multimesh.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.multimesh.color_format = MultiMesh.COLOR_FLOAT
	multimesh.multimesh.instance_count = instances
	multimesh.multimesh.visible_instance_count  = instances
	multimesh.multimesh.mesh = $MeshInstance2.mesh
	
	# space between spirals
	var a = 0.4
	var b = 0.1
	
	var x = 0
	var y = 0
	var angle = 0.0
	 
	for i in range(instances):
		a = rand_range(0.4,0.8)
		b = rand_range(0.1,0.4)
		var t = Transform.IDENTITY
		angle = 0.1 * i
		x = (a+b*angle)*cos(angle)
		y = (a+b*angle)*sin(angle)
		var s = rand_range(0.2,1.4)
		t = t.scaled(Vector3(s,s,s))
		t.origin = Vector3(x,0,y)
		multimesh.multimesh.set_instance_transform(i,t)
		multimesh.multimesh.set_instance_color(i,instColor)


func _physics_process(_delta):
	multimesh.rotate(Vector3(0,1,0),0.02*_delta)
