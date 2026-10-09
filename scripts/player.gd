extends CharacterBody2D

@export_group("movment")
@export var speed : float = 300.0
@export var friction : float = 300.0
var knockback : Vector2 = Vector2(0,0)

@export_group("polish")
@export var anim : AnimationPlayer
@export var sprite : Sprite2D
@export var timePerStep : float = 0.2
var stepTimer : float = 0

@export_group("lava collision")
@export var collider : TileMapLayer

func input():
	var temp : Vector2
	temp.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	temp.y = Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")
	return temp

func _process(_delta):
	var vel : float = input().length()
	if vel > 0 :
		anim.play("run")
		stepTimer -= _delta
		if stepTimer < 0:
			stepTimer = timePerStep
			SOUND.playSound("step")
	else:
		anim.play("idle")

func _physics_process(_delta):
	var moveDir : Vector2 = input()
	if moveDir != Vector2(0,0) : moveDir = moveDir.normalized()
	
	var grounded : bool = collider.isOverlap(position)
	velocity = moveDir * speed + knockback
	knockback = knockback.move_toward(Vector2.ZERO, friction * _delta)
	
	if abs(moveDir.x) > 0:
		sprite.flip_h = moveDir.x < 0
	
	move_and_slide()

func hit(pos : Vector2, strength : float):
	knockback += (position - pos).normalized() * strength
	SOUND.playSound("hurt")
