extends Node2D

var speed : float = 500
var maxLifeTime : float = 5.0
var timeLived : float = 0.0
var damping : float = 100.0

var pierceAmount: int = 1.0
var timePerPierce: float = 1.0
var currentPierces: int = 0
var piercesTimer: float = 0

var knockBackStrength : float = 100.0

var enemy : Node2D

func _ready():
	currentPierces = pierceAmount

func _physics_process(_delta):
	position += transform.x * speed * _delta
	speed = max(speed - damping * _delta, 0)

func _process(_delta):
	timeLived += _delta
	if timeLived > maxLifeTime or currentPierces <= 0:
		queue_free()
	
	if enemy != null:
		if piercesTimer <= 0:
			enemy.knockback += (enemy.position - position).normalized() * (knockBackStrength - enemy.knockBackRes)
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
