extends TileMapLayer

@export_group("generation")
var rng = RandomNumberGenerator.new()
var cells: Array[Vector2i] = []
@export var tileMap : TileMapLayer
@export var maxCellsCount : int = 50
@export var maxWalks : int = 10
@export_range(0, 1, 0.05) var chanceToRotate : float = 0
var walksCount : int = 0

var denom : float = 1.0 / sqrt(2.0)

@export_group("lava")
@export var lava : Polygon2D

func _ready():
	walk()
	lava.material.set_shader_parameter("tilesTexture", tilesTexture())

	var half := Vector2(tileMap.tile_set.tile_size) / 2.0
	var a := lava.to_local(tileMap.to_global(tileMap.map_to_local(Vector2i(-13, -7)) - half))
	var b := lava.to_local(tileMap.to_global(tileMap.map_to_local(Vector2i(15, 9)) - half))
	lava.material.set_shader_parameter("rect_min", a)
	lava.material.set_shader_parameter("rect_max", b)

	tileMap.set_cells_terrain_connect(cells, 0, 0)

func tilesTexture():
	var image := Image.create(28, 16, false, Image.FORMAT_R8)
	for cell in cells:
		var px := cell.x + 13
		var py := cell.y + 7
		if px >= 0 and px < 28 and py >= 0 and py < 16:
			image.set_pixel(px, py, Color.WHITE)
	return ImageTexture.create_from_image(image)

func isOverlap(pos : Vector2):
	for cell in cells:
		var delta = pos - (Vector2(cell * 80) + Vector2(40, 0))
		if (abs(delta.x - delta.y) * denom + abs(delta.y + delta.x) * denom) * denom < 40.0:
			return true
	return false

func walk():
	var x : int = 0
	var y : int = 0
	var angle : float = rng.randi_range(0, 3) * 90
	while x >= -12 and x <= 12 and y >= -6 and y <= 6:
		if cells.size() >= maxCellsCount : break
		if rng.randf() < chanceToRotate : angle += (randi_range(0, 1) - 0.5) * 180.0
		x += int(cos(deg_to_rad(angle)))
		y += int(sin(deg_to_rad(angle)))
		for oX in 2: for oY in 2: if not cells.has(Vector2i(x + oX, y + oY)): cells.append(Vector2i(x + oX, y + oY))
	walksCount += 1
	if cells.size() <= maxCellsCount and walksCount <= maxWalks: walk()
