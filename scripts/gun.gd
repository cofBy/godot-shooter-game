extends Node2D

var timer: float

var currentBullets : int
var reloadTimer : float = 0
var startReload : bool = false
var rng = RandomNumberGenerator.new()

@export var data : Resource
@export var holder : CharacterBody2D
@export var isEnemy : bool = false
@onready var anim : AnimationPlayer = $"gun animations"

func _ready():
	currentBullets = data.magSize
	
	var gunSprite : Sprite2D = $"gun sprite"
	gunSprite.texture = data.gunTexture
	gunSprite.position = data.gunOffset

func _process(_delta):
	timer -= _delta
	if !isEnemy:
		if data.autoFire:
			if Input.is_action_pressed("shoot"):
				tryShoot(rotation)
		else:
			if Input.is_action_just_pressed("shoot"):
				tryShoot(rotation)
	
	if data.magSize > 0 and (currentBullets <= 0 or Input.is_action_just_pressed("reload") and currentBullets < data.magSize):
		if startReload == false:
			SOUND.playSound("reload")
			anim.play("reload")
		startReload = true
	if startReload:
		reloadTimer += _delta
		if reloadTimer > data.reloadTime:
			currentBullets = data.magSize
			startReload = false
			reloadTimer = 0
	
	var target : Vector2 = Vector2(1, 0)
	if isEnemy:
		if holder.state != holder.STATES.idle: target = holder.player.position
	else:
		target = get_global_mouse_position()
		
	if target.x > holder.position.x:
		scale.y = 1
	else:
		scale.y = -1
	var direction : Vector2 = target - holder.position
	rotation = atan2(direction.y, direction.x) + data.addedAngle

func tryShoot(angle: float):
	if timer < 0 and reloadTimer <= 0: fire(angle)

func fire(angle: float):
	currentBullets -= 1
	timer = data.fireRate
	for i in data.bulletAmount:
		if data.isMelee:
			anim.play("meleeHit")
		else:
			anim.play("shoot")
			SOUND.playSound("shoot")
		var bulletInstance = data.bullet.instantiate();
		bulletInstance.position = get_child(0).global_position
		
		var randomAngle : float = deg_to_rad(rng.randf_range(-data.randomRange*0.5, data.randomRange*0.5))
		var mainAngle : float = (float(i) - 0.5) / data.bulletAmount * deg_to_rad(data.maxRange)
		var bulletAngle : float = angle + mainAngle + randomAngle
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
		if isEnemy:
			bulletInstance.hitGroup = "player"
		else:
			bulletInstance.hitGroup = "enemy"
		get_tree().root.add_child(bulletInstance)
	
	holder.knockback += -Vector2(cos(rotation), sin(rotation)) * data.playerKnockBack
