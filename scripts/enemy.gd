extends CharacterBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var gun: Node2D = $gun
var rng = RandomNumberGenerator.new()

@export_group("knockBack")
@export var knockBackRes : float = 100.0
@export var friction : float = 200.0
var knockback : Vector2 = Vector2.ZERO

@export_group("states settings")
@export_subgroup("agro")
@export var agroRadius : float = 500

@export_subgroup("follow")
@export var baseSpeed : float = 500
@export var acceleration : float = 100
var player : CharacterBody2D
var speed : float = 0

@export_subgroup("shooting")
@export var shootingRadius : float = 500
@export_range(0.0, 0.05, 0.001) var shootChance : float 

enum STATES{
	idle,
	agro,
	follow,
	shoot
}
var state : STATES = STATES.idle
@onready var stateDisplay : Label = $Label

func _process(_delta):
	if state == STATES.idle:
		if (player.position - position).length() < agroRadius:
			state = STATES.agro
	elif state != STATES.agro:
		if (player.position - position).length() < shootingRadius:
			state = STATES.shoot
		else:
			state = STATES.follow

func _physics_process(delta: float):
	velocity = (player.position - position).normalized() * speed + knockback
	stateDisplay.text = STATES.keys()[state]
	match state:
		STATES.idle:
			anim.play("idle")
		STATES.agro:
			anim.play("agro")
			if anim.current_animation == "agro" and anim.current_animation_position == 0.55: state = STATES.follow
		STATES.follow:
			anim.play("run")
			speed = move_toward(speed, baseSpeed, acceleration * delta)
			knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
		STATES.shoot:
			var direction : Vector2 = (player.position - position)
			if rng.randf_range(0, 1) < shootChance:
				gun.tryShoot(atan2(direction.y, direction.x))
	
	move_and_slide()

func hit(pos : Vector2, strength : float):
	knockback += (position - pos).normalized() * (strength - knockBackRes)
	SOUND.playSound("hurt")
	if state == STATES.idle : state = STATES.agro
