extends CharacterBody2D

@export var speed = 300.0

@export var gun: Node2D

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
	
	velocity = moveDir * speed * _delta
	var mousePos = get_global_mouse_position()
	gun.look_at(mousePos)
	if mousePos.x > position.x:
		anim.scale.x = 5
		gun.scale.y = 1
	else:
		anim.scale.x = -5
		gun.scale.y = -1
	
	move_and_slide()
