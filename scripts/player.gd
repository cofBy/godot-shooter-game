extends CharacterBody2D

@export var speed : float = 300.0
@export var friction : float = 300.0
var knockback : Vector2 = Vector2(0,0)

@export var anim: AnimatedSprite2D

func input():
	var temp: Vector2
	temp.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	temp.y = Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")
	return temp

func _process(_delta):
	var vel : float = input().length()
	if vel > 0 :
		anim.play("run")
	else:
		anim.play("idle")

func _physics_process(_delta):
	var moveDir : Vector2 = input().normalized()
	
	velocity = moveDir * speed + knockback
	knockback = knockback.move_toward(Vector2.ZERO, friction * _delta)
	
	if abs(moveDir.x) > 0:
		if moveDir.x > 0:
			anim.scale.x = 5
		else:
			anim.scale.x = -5
	
	move_and_slide()
