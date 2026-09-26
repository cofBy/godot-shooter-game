extends CharacterBody2D

@export_group("knockBack")
@export var knockBackRes : float = 100.0
@export var friction : float = 200.0
var knockback : Vector2 = Vector2.ZERO

func _physics_process(_delta: float):
	velocity = knockback
	knockback = knockback.move_toward(Vector2.ZERO, friction * _delta)
	
	move_and_slide()
