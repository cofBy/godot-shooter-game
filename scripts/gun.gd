extends Node2D

@export_group("cooldown")
@export var fireRate = 0.5
@export var autoFire := false
var timer: float

@export_group("instansiating bullets")
@export var bulletDistance = 100.0
@export var bullet: PackedScene

@export var bulletAmount = 1
@export var range = 45.0
@export var random := false

@export_group("knockBack")
@export var player: CharacterBody2D
@export var knockBack: float = 500.0

func _process(_delta):
	timer -= _delta
	if autoFire:
		if Input.is_action_pressed("shoot") and timer < 0:
			fire()
	else:
		if Input.is_action_just_pressed("shoot") and timer < 0:
			fire()
	
	var mousePos = get_global_mouse_position()
	if mousePos.x > position.x:
		scale.y = 1
	else:
		scale.y = -1
	look_at(mousePos)

func fire():
	timer = fireRate
	for i in bulletAmount:
		var bulletInstance = bullet.instantiate();
		bulletInstance.position = get_child(0).global_position
		if random == false:
			bulletInstance.rotation = rotation + ((float(i) - 0.5) / bulletAmount * deg_to_rad(range))
		else:
			bulletInstance.rotation = rotation + deg_to_rad(RandomNumberGenerator.new().randf_range(-range*0.5, range*0.5))
		get_tree().root.add_child(bulletInstance)
	
	player.knockback += -Vector2(cos(rotation), sin(rotation)) * knockBack
