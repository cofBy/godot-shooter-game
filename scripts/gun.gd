extends Node2D

@export_group("projectile movment")
@export var bulletSpeed : float = 500
@export var bulletLifeTime: float = 3.0
@export var damping: float = 50.0

@export_subgroup("pierce")
@export var pierceAmount: int = 1
@export var timePerPierce: float = 1.0

@export_subgroup("ricochet")
@export var ricochetCount : int = 2
@export_range(0.0, 1.0) var ricochetStrength : float = 0.8

@export_subgroup("homing bullets")
@export_range(0.0, 1.0) var homingStrength : float = 0.2
@export var homingRadius : float = 200

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
var startReload : bool = false

@export_group("knockBack")
@export var player : CharacterBody2D
@export var playerKnockBack : float = 500.0
@export var knockBackStrength : float = 600.0

@export_group("exploding bullets")
@export var expRadius : float = 600
@export var expKnockBackMultiplier : float = 2

func _ready():
	currentBullets = magSize

func _process(_delta):
	timer -= _delta
	if timer < 0 and reloadTimer <= 0:
		if autoFire:
			if Input.is_action_pressed("shoot"):
				fire()
		else:
			if Input.is_action_just_pressed("shoot"):
				fire()
	
	if currentBullets <= 0 or Input.is_action_just_pressed("reload") and currentBullets < magSize:
		startReload = true
	if startReload:
		reloadTimer += _delta
		if reloadTimer > reloadTime:
			currentBullets = magSize
			startReload = false
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
		var bulletAngle : float = rotation + mainAngle + randomAngle
		bulletInstance.initialRotation = Vector2(cos(bulletAngle), sin(bulletAngle))
		
		bulletInstance.speed = bulletSpeed
		bulletInstance.maxLifeTime = bulletLifeTime
		bulletInstance.damping = damping
		bulletInstance.knockBackStrength = knockBackStrength
		bulletInstance.pierceAmount = pierceAmount
		bulletInstance.timePerPierce = timePerPierce
		bulletInstance.homingRadius = homingRadius
		bulletInstance.homingStrength = homingStrength
		bulletInstance.expRadius = expRadius
		bulletInstance.expKnockBackMultiplier = expKnockBackMultiplier
		bulletInstance.ricochetCount = ricochetCount
		bulletInstance.ricochetStrength = ricochetStrength
		get_tree().root.add_child(bulletInstance)
	
	player.knockback += -Vector2(cos(rotation), sin(rotation)) * playerKnockBack
