extends Node2D

@export_group("projectile settings")
@export var bulletSpeed : float = 500
@export var bulletLifeTime: float = 3.0

@export_group("cooldown")
@export var fireRate : float = 0.5
@export var autoFire : bool = false
var timer: float

@export_group("instansiating bullets")
@export var bulletDistance : float = 100.0
@export var bullet: PackedScene

@export var bulletAmount : int = 1
@export var maxRange : float = 45.0
@export var randomRange : float = 10.0

@export_group("reload")
@export var magSize : int = 2
@export var reloadTime : float = 1
var currentBullets : int
var reloadTimer : float = 0

@export_group("knockBack")
@export var player: CharacterBody2D
@export var knockBack: float = 500.0

func _ready():
	currentBullets = magSize

func _process(_delta):
	timer -= _delta
	
	if timer < 0 and currentBullets > 0:
		if autoFire:
			if Input.is_action_pressed("shoot"):
				fire()
		else:
			if Input.is_action_just_pressed("shoot"):
				fire()
	
	if currentBullets <= 0:
		reloadTimer += _delta
		if reloadTimer > reloadTime:
			currentBullets = magSize
			reloadTimer = 0
	
	var mousePos = get_global_mouse_position()
	if mousePos.x > position.x:
		scale.y = 1
	else:
		scale.y = -1
	look_at(mousePos)

func fire():
	currentBullets -= 1
	timer = fireRate
	for i in bulletAmount:
		var bulletInstance = bullet.instantiate();
		bulletInstance.position = get_child(0).global_position
		
		var randomAngle : float = deg_to_rad(RandomNumberGenerator.new().randf_range(-randomRange*0.5, randomRange*0.5))
		var mainAngle : float = (float(i) - 0.5) / bulletAmount * deg_to_rad(maxRange)
		bulletInstance.rotation = rotation + mainAngle + randomAngle
		
		bulletInstance.speed = bulletSpeed
		bulletInstance.maxLifeTime = bulletLifeTime
		get_tree().root.add_child(bulletInstance)
	
	player.knockback += -Vector2(cos(rotation), sin(rotation)) * knockBack
