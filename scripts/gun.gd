extends Node2D

@export var bulletDistance = 100.0
@export var shootCoolDown = 0.5
var timer: float
@export var bullet: PackedScene

func _process(_delta):
	timer -= _delta
	if (Input.is_action_just_pressed("shoot") and timer < 0):
		timer = shootCoolDown
		var bulletInstance = bullet.instantiate();
		
		bulletInstance.position = get_child(0).global_position
		bulletInstance.rotation = rotation
		get_tree().root.add_child(bulletInstance)
