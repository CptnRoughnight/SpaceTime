extends Spatial

onready var mesh = $MeshInstance


func _ready():
	normalSun()
	#roterRiese()
	
	
	
func normalSun():
	var mat = mesh.mesh.surface_get_material(0)
	mat.set_shader_param("Sun_Color",Color(1,1,0,1))
	mesh.scale = Vector3(1,1,1)
	
	
func roterRiese():
	var mat = mesh.mesh.surface_get_material(0)
	mat.set_shader_param("Sun_Color",Color(1,0,0,1))
	mesh.scale = Vector3(3,3,3)
