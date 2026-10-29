extends Control

@export var text : String

@export_group("instancing sprites")
@export var charSprite : PackedScene
@export var selectTextures : Array[Texture2D]
var chartInstances : Array[TextureRect]

@export_group("positioning")
@export var spacing : float

@export_subgroup("wobble")
@export var wobbleSpeed : float
@export var wobbleRange : float
@export var wobbleFrequancy : float
@export var wobbleAxis : Vector2
var time : float

@export_subgroup("rotation wiggle")
@export var wiggleSpeed : float
@export var wiggleFrequancy : float
@export var wiggleRange : float

func _ready():
	for i in text.length():
		var chartInstance = charSprite.instantiate()
		add_child(chartInstance)
		chartInstances.append(chartInstance)

func _process(delta: float):
	time += delta
	for i in chartInstances.size():
		var char = chartInstances[i]
		char.position = Vector2(i * spacing, 0) + wobbleRange * sin(char.position.x * wobbleFrequancy + time * wobbleSpeed) * wobbleAxis
		char.rotation = deg_to_rad(wiggleRange) * sin(char.position.x * wiggleFrequancy + time * wiggleSpeed)
		if text[i] == " " : char.texture = null
		else: char.texture = selectTextures[getTexture(text[i])]

func getTexture(char: String):
	for i in selectTextures.size():
		var current : String = selectTextures[i].resource_path[13]
		if current == char: return i
	return 0
