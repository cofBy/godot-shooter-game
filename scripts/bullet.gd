extends Node2D

var initialRotation := Vector2.ZERO
var speed : float = 500
var maxLifeTime : float = 5.0
var timeLived : float = 0.0
var damping : float = 100.0

var pierceAmount: int = 1
var timePerPierce: float = 1.0
var currentPierces: int = 0
var piercesTimer: float = 0

var knockBackStrength : float = 100.0

var homingStrength : float = 0.2
var homingRadius : float = 200
@onready var homingArea : Area2D = $"homing area"

var expRadius : float = 200.0
var expKnockBackMultiplier : float = 2.0
@onready var expArea : Area2D = $"explosion area"

var enemy : Node2D

func _ready():
	currentPierces = pierceAmount
	homingArea.scale = homingRadius * Vector2.ONE
	expArea.scale = expRadius * Vector2.ONE

func _physics_process(_delta):
	var bodies : Array[Node2D] = homingArea.get_overlapping_bodies()
	var closestBody : Node2D
	var closestDistance : float = 99999
	for i in bodies:
		if not i.is_in_group("enemy") : continue
		var dir : Vector2 = i.position - position
		if dir.length() < closestDistance:
			closestDistance = dir.length()
			closestBody = i
	
	var homingDir := Vector2.ZERO
	var homingDistance := 0.0
	if closestBody != null:
		homingDir = (closestBody.position - position).normalized()
		homingDistance = (1.0 - closestDistance / homingRadius)
	else:
		homingDir = Vector2.ZERO
		homingDistance = 0.0
	
	var dir : Vector2 = lerp(initialRotation, homingDir, homingStrength * homingDistance)
	rotation = atan2(dir.y, dir.x)
	position += transform.x * speed * _delta
	speed = max(speed - damping * _delta, 0)

func _process(_delta):
	timeLived += _delta
	if timeLived > maxLifeTime or currentPierces <= 0:
		var bodies : Array[Node2D] = expArea.get_overlapping_bodies()
		for i in bodies:
			if not i.is_in_group("enemy") : continue
			if i == enemy : continue
			
			var dst : float = 1 - clampf((position - i.position).length() / expRadius, 0, 1)
			i.hit(position, knockBackStrength * expKnockBackMultiplier * dst)
		
		queue_free()
	
	if enemy != null:
		if piercesTimer <= 0:
			enemy.hit(position, knockBackStrength)
			currentPierces -= 1
			piercesTimer = timePerPierce
		else:
			piercesTimer -= _delta

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		enemy = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy = null
