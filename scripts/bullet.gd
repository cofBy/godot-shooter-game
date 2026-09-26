extends Node2D

@export var speed = 10000

func _physics_process(delta):
	position += transform.x * speed * delta
