class_name gunData
extends Resource

@export var isMelee : bool = false

@export_group("visuals")
@export var gunTexture : Texture2D
@export var addedAngle : float = 0.0
@export var gunOffset : Vector2

@export_group("projectile movment")
@export var bulletSpeed : float = 500
@export var bulletLifeTime: float = 3.0
@export var damping: float = 50.0

@export_subgroup("pierce")
@export var pierceAmount: int = 1
@export var timePerPierce: float = 1.0

@export_subgroup("ricochet")
@export var ricochetCount : int = 2
@export_range(0.0, 1.0) var ricochetStrength : float = 0.8

@export_subgroup("homing bullets")
@export_range(0.0, 1.0) var homingStrength : float = 0.2
@export var homingRadius : float = 200

@export_group("cooldown")
@export var fireRate : float = 0.5
@export var autoFire : bool = false

@export_group("instansiating bullets")
@export var bulletDistance : float = 100.0
@export var bullet: PackedScene

@export var bulletAmount : int = 1
@export var maxRange : float = 45.0
@export var randomRange : float = 10.0

@export_group("reload")
@export var magSize : int = 2
@export var reloadTime : float = 1

@export_group("knockBack")
@export var playerKnockBack : float = 500.0
@export var knockBackStrength : float = 600.0

@export_group("exploding bullets")
@export var expRadius : float = 600
@export var expKnockBackMultiplier : float = 2
