extends Node2D

var speed : float = 500
var maxLifeTime : float = 5.0
var timeLived : float = 0.0
var damping : float = 100.0

var knockBackStrength : float = 100.0

func _physics_process(_delta):
	position += transform.x * speed * _delta
	speed = max(speed - damping * _delta, 0)

func _process(_delta):
	timeLived += _delta
	if timeLived > maxLifeTime:
		queue_free()

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		body.knockback += (body.position - position).normalized() * (knockBackStrength - body.knockBackRes)
		print((body.position - position).normalized() * (knockBackStrength - body.knockBackRes))
