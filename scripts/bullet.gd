extends Node2D

var speed : float = 500
var maxLifeTime : float = 5.0
var timeLived : float = 0.0

func _physics_process(_delta):
	position += transform.x * speed * _delta

func _process(_delta):
	timeLived += _delta
	if timeLived > maxLifeTime:
		queue_free()
