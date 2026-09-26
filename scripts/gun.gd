extends Node2D

@export var shootCoolDown = 0.5
var timer: float

@export var bulletDistance = 100.0
@export var bullet: PackedScene

@export var player: CharacterBody2D
@export var knockBack: float = 500.0

func _process(_delta):
	timer -= _delta
	if (Input.is_action_just_pressed("shoot") and timer < 0):
		timer = shootCoolDown
		var bulletInstance = bullet.instantiate();
		bulletInstance.position = get_child(0).global_position
		bulletInstance.rotation = rotation
		get_tree().root.add_child(bulletInstance)
		
		player.knockback += -Vector2(cos(rotation), sin(rotation)) * knockBack
	
	var mousePos = get_global_mouse_position()
	if mousePos.x > position.x:
		scale.y = 1
	else:
		scale.y = -1
	look_at(mousePos)
