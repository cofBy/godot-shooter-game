extends TileMapLayer

@export var tileMap : TileMapLayer

var rng = RandomNumberGenerator.new()
var cells: Array[Vector2i] = []

@export var maxCellsCount : int = 50
@export var maxWalks : int = 10
var walksCount : int = 0

@export_range(0, 1, 0.05) var chanceToRotate : float = 0

func _ready():
	walk()
	tileMap.set_cells_terrain_connect(cells, 0, 0)

func walk():
	var x : int = 0
	var y : int = 0
	var angle : int = rng.randi_range(0, 3) * 90
	while x >= -12 and x <= 12 and y >= -6 and y <= 6:
		if cells.size() >= maxCellsCount : break
		if rng.randf() < chanceToRotate : angle += (randi_range(0, 1) - 0.5) * 180
		x += cos(deg_to_rad(angle))
		y += sin(deg_to_rad(angle))
		for oX in 2: for oY in 2: if not cells.has(Vector2i(x + oX, y + oY)): cells.append(Vector2i(x + oX, y + oY))
	walksCount += 1
	if cells.size() <= maxCellsCount and walksCount <= maxWalks: walk()
