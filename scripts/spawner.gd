extends Node2D

@export var player : CharacterBody2D

@export_group("portal")
@export var portal : PackedScene
@export var timeForPortal : float = 1
var portalTimer : float = timeForPortal
var rng = RandomNumberGenerator.new()

@export_group("enemies")
@export var enemies : Array[PackedScene]
@export var minTimePerSpawn : float = 2
@export var maxTimePerSpawn : float = 3
var spawnTimer : float = minTimePerSpawn 
var portalInstance : Node2D
var pos : Vector2
@export_subgroup("positioning")
@export var map : Node
@export_subgroup("gun")
@export var gunTypes: Dictionary[Resource, float] = {}

func _process(delta):
	spawnTimer -= delta
	if player != null and spawnTimer < 0:
		if portalTimer == timeForPortal:
			pos = Vector2(map.cells[randi_range(0, map.cells.size() - 1)]) * 80 + Vector2(40, 0)
			portalInstance = portal.instantiate()
			portalInstance.position = pos
			portalInstance.get_child(0).play("default")
			add_child(portalInstance)
			SOUND.playSound("portalSpawn")
		
		portalTimer -= delta
		if portalTimer < 0:
			portalTimer = timeForPortal
			spawnTimer = rng.randf_range(minTimePerSpawn, maxTimePerSpawn)
			if portalInstance != null : portalInstance.queue_free()
			
			var enemyInstance = enemies[rng.randi_range(0, enemies.size() - 1)].instantiate()
			enemyInstance.position = pos
			enemyInstance.collider = map
			if player != null: enemyInstance.player = player
			var rnd = rng.randf()
			for gun in gunTypes:
				if rnd >= gunTypes[gun]:
					enemyInstance.gunType = gun
					break
				enemyInstance.gunType = gun
			
			add_child(enemyInstance)
			enemyInstance.gun.init()
			
			SOUND.playSound("enemySpawn")
