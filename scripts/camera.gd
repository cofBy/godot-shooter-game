extends Camera2D

@export_group("movment")
@export var speed  : float
@export var player : CharacterBody2D
@export var maxAimInfluince : float
var enemies : Array[CharacterBody2D]
@export_range(0.0, 1.0, 0.05) var playerWeight : float
@export_range(0.0, 1.0, 0.05) var aimWeight : float

func _process(_delta : float):
	var enemiesSum : Vector2 = Vector2(0,0)
	if enemies.size() > 0: for e in enemies.size():
		if enemies[e] == null:
			enemies.remove_at(e)
			break
		enemiesSum += enemies[e].position
	
	var localMouse : Vector2 = get_global_mouse_position() - player.position
	var aim : Vector2 = min2(localMouse, localMouse.normalized() * maxAimInfluince)
	
	var target : Vector2 = lerp(enemiesSum / (enemies.size() + float(enemies.size() == 0)), player.position, playerWeight)
	target = lerp(target, aim, aimWeight)
	position = lerp(position, target, speed * _delta)

func min2(x : Vector2, y : Vector2):
	return (x + y - Vector2(abs(x.x - y.x), abs(x.y - y.y))) * 0.5
