extends Node

var viewport_container
var viewport



enum TIMEPERIOD{
	STEINZEIT,				# staubwolke
	NORMAL,					# sonne
	ROTERRIESE,				# roter riese
	BLACKHOLE				# schwarzes Loch
}


var currentTimePeriod = TIMEPERIOD.NORMAL



var health = preload("res://items/HealthPotion.tscn")


var numGegnerPerTimePeriod = [
	16,
	16,
	24,
	48	
]

var hasBoss = [
	false,
	false,
	true,
	true
]


# null -> kein tesseract - möglicher Boss
# Vector(0,0) -> random position

var tesseractPosition = [
	null,									# steinzeit
	Vector2(0,0),							# normal      - start
	Vector2(0,0),							# roterriese
	null,									# schwarzes loch
]


var collectedTesseract = [
	null,
	null,
	null,
	null
]


var PointsOfInterest = [
	
]



func start():
	currentTimePeriod = TIMEPERIOD.NORMAL
	for i in range(0,3):
		collectedTesseract[i] = null

func getRandomPoint(minDistance,maxDistance):
	var angle = rand_range(0,2*PI)
	var point = Vector2.RIGHT.rotated(angle)*rand_range(minDistance,maxDistance)
	return point
