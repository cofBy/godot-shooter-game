extends CharacterBody2D

@export var speed = 300.0

@export var bulletDistance = 100.0
@export var shootCoolDown = 0.5
var timer: float
@export var gun: Node2D
@export var bullet: PackedScene

@export var anim: AnimatedSprite2D

func input():
	var temp: Vector2
	temp.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	temp.y = Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")
	return temp

func _process(_delta):
	timer -= _delta
	if (Input.is_action_just_pressed("shoot") and timer < 0):
		timer = shootCoolDown
		var bulletInstance = bullet.instantiate();
		
		var angle = deg_to_rad(gun.rotation_degrees);
		bulletInstance.position = position + Vector2(cos(angle), sin(angle)) * bulletDistance
		bulletInstance.rotation = gun.rotation
		get_tree().root.add_child(bulletInstance)
		
	var vel = input().length()
	if (vel > 0):
		anim.play("run")
	else:
		anim.play("idle")

func _physics_process(_delta):
	var moveDir = input().normalized()
	
	velocity = moveDir * speed * _delta
	var mousePos = get_global_mouse_position()
	gun.look_at(mousePos)
	
	move_and_slide()
