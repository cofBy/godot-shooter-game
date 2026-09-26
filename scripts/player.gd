extends CharacterBody2D

@export var speed = 300.0
@export var friction = 300.0
var knockback := Vector2(0,0)

@export var anim: AnimatedSprite2D

func input():
	var temp: Vector2
	temp.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	temp.y = Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")
	return temp

func _process(_delta):
	var vel = input().length()
	if vel > 0 :
		anim.play("run")
	else:
		anim.play("idle")

func _physics_process(_delta):
	var moveDir = input().normalized()
	
	velocity = moveDir * speed + knockback
	knockback = knockback.move_toward(Vector2.ZERO, friction * _delta)
	
	if moveDir.x > 0:
		anim.scale.x = 5
	else:
		anim.scale.x = -5
	
	move_and_slide()
