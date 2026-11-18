extends CharacterBody2D

@export var gun : Node2D
@export_group("movment")
var knockback : Vector2 = Vector2(0,0)

@export_group("polish")
@export var anim : AnimationPlayer
@export var sprite : Sprite2D
@export var timePerStep : float = 0.2
var stepTimer : float = 0

@export_group("lava collision")
@export var collider : Node
@export var deadParticle : PackedScene
var isDead : bool
signal died

@export_group("score")
@export var score : int = 0

@export_group("character")
@export var sprites  : Array[Texture2D]
@export var gunTypes : Array[Resource]
@export var speeds   : Array[float]
@export var frictions: Array[float]
var spriteToUse : int

func _ready():
	gun.data = gunTypes[SOUND.selectedCharacter]
	gun.init()

func input():
	var temp : Vector2
	temp.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	temp.y = Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")
	return temp

func _process(_delta):
	sprite.texture = sprites[spriteToUse + SOUND.selectedCharacter * 4]
	var vel : float = input().length()
	if vel > 0 :
		anim.play("run")
		stepTimer -= _delta
		if stepTimer < 0:
			stepTimer = timePerStep
			SOUND.playSound("step")
	else:
		anim.play("idle")
	
	if not collider.isOverlap(position) and isDead == false:
		die()
		SOUND.playSound("lose")
		isDead = true

func _physics_process(_delta):
	var moveDir : Vector2 = input()
	if moveDir != Vector2(0,0) : moveDir = moveDir.normalized()
	
	knockback = knockback.move_toward(Vector2.ZERO, frictions[SOUND.selectedCharacter] * _delta)
	
	if abs(moveDir.x) > 0:
		sprite.flip_h = moveDir.x < 0
	
	velocity = moveDir * speeds[SOUND.selectedCharacter] + knockback
	move_and_slide()

func die():
	var particleInstnace = deadParticle.instantiate()
	get_tree().root.add_child(particleInstnace)
	particleInstnace.position = position
	particleInstnace.texture = sprites[3 + SOUND.selectedCharacter * 4]
	particleInstnace.restart()
	particleInstnace.get_child(0).restart()
	visible = false
	died.emit()
	SOUND.cameraShake(60, 0.5)


func hit(pos : Vector2, strength : float):
	knockback += (global_position - pos).normalized() * strength
	SOUND.playSound("hurt")
	SOUND.cameraShake(6, 0.07)
