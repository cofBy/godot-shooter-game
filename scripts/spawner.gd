extends Node2D

@export_group("portal")
@export var portal : PackedScene
@export var timeForPortal : float = 1
var portalTimer : float = timeForPortal
var rng = RandomNumberGenerator.new()

@export_group("enemies")
@export var blSpawnCorner : Vector2
@export var trSpawnCorner : Vector2
@export var enemies : Array[PackedScene]
@export var minTimePerSpawn : float = 2
@export var maxTimePerSpawn : float = 3
var spawnTimer : float = minTimePerSpawn 
var portalInstance : Node2D
var pos : Vector2

func _process(delta):
	spawnTimer -= delta
	if spawnTimer < 0:
		if portalTimer == timeForPortal:
			pos = Vector2(randf_range(blSpawnCorner.x, trSpawnCorner.x), randf_range(trSpawnCorner.y, blSpawnCorner.y))
			portalInstance = portal.instantiate()
			portalInstance.position = pos
			add_child(portalInstance)
		
		portalTimer -= delta
		if portalTimer < 0:
			portalTimer = timeForPortal
			spawnTimer = rng.randf_range(minTimePerSpawn, maxTimePerSpawn)
			if portalInstance != null : portalInstance.queue_free()
			
			var enemyInstance = enemies[rng.randi_range(0, enemies.size() - 1)].instantiate()
			enemyInstance.position = pos
			add_child(enemyInstance)
			
