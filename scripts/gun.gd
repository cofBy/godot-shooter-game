extends Node2D

var timer: float

var currentBullets : int
var reloadTimer : float = 0
var startReload : bool = false

@export var data : Resource
@export var player : CharacterBody2D

func _ready():
	currentBullets = data.magSize
	$Sprite2D.texture = data.gunTexture

func _process(_delta):
	timer -= _delta
	if timer < 0 and reloadTimer <= 0:
		if data.autoFire:
			if Input.is_action_pressed("shoot"):
				fire()
		else:
			if Input.is_action_just_pressed("shoot"):
				fire()
	
	if currentBullets <= 0 or Input.is_action_just_pressed("reload") and currentBullets < data.magSize:
		startReload = true
	if startReload:
		reloadTimer += _delta
		if reloadTimer > data.reloadTime:
			currentBullets = data.magSize
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
	timer = data.fireRate
	for i in data.bulletAmount:
		var bulletInstance = data.bullet.instantiate();
		bulletInstance.position = get_child(0).global_position
		
		var randomAngle : float = deg_to_rad(RandomNumberGenerator.new().randf_range(-data.randomRange*0.5, data.randomRange*0.5))
		var mainAngle : float = (float(i) - 0.5) / data.bulletAmount * deg_to_rad(data.maxRange)
		var bulletAngle : float = rotation + mainAngle + randomAngle
		bulletInstance.initialRotation = Vector2(cos(bulletAngle), sin(bulletAngle))
		
		bulletInstance.speed                  = data.bulletSpeed
		bulletInstance.maxLifeTime            = data.bulletLifeTime
		bulletInstance.damping                = data.damping
		bulletInstance.knockBackStrength      = data.knockBackStrength
		bulletInstance.pierceAmount           = data.pierceAmount
		bulletInstance.timePerPierce          = data.timePerPierce
		bulletInstance.homingRadius           = data.homingRadius
		bulletInstance.homingStrength         = data.homingStrength
		bulletInstance.expRadius              = data.expRadius
		bulletInstance.expKnockBackMultiplier = data.expKnockBackMultiplier
		bulletInstance.ricochetCount          = data.ricochetCount
		bulletInstance.ricochetStrength       = data.ricochetStrength
		get_tree().root.add_child(bulletInstance)
	
	player.knockback += -Vector2(cos(rotation), sin(rotation)) * data.playerKnockBack
