extends Control

@export var text : String

@export_group("instancing sprites")
@export var charSprite : PackedScene
const selectTextures : Array[Texture2D] = [
 preload("uid://drtjtrw2exs5p"),
 preload("uid://bnje2k0ppv3mv"),
 preload("uid://banlj80j6mw8k"),
 preload("uid://cwyo38kd2erjv"),
 preload("uid://bsdwcjgyt1e7e"),
 preload("uid://batvrd651bmc6"),
 preload("uid://ctnowxwpfc0fa"),
 preload("uid://b4psveyjbtfbv"),
 preload("uid://c7d0a7k4jxuun"),
 preload("uid://c0s87twf33a6"),
 preload("uid://dmwnii0swnmeu"),
 preload("uid://dlui2qf65td52"),
 preload("uid://jvce65h6407w"),
 preload("uid://dckqk5e6ghsuk"),
 preload("uid://twcj0lmbxl4e"),
 preload("uid://bir38iiy5o01n"),
 preload("uid://ff6j86l2cvk3"),
 preload("uid://ewuslcrg8ao2"),
 preload("uid://dkbhj1glghi8g"),
 preload("uid://cvt1k6f225d2e"),
 preload("uid://dty8dha2fn23k"),
 preload("uid://dae1lp5t3saxg"),
 preload("uid://cytlv51c8s4bk"),
 preload("uid://rokcwmfvqrsh"),
 preload("uid://cym1s0n7abywa"),
 preload("uid://d2ndxs3dnymsu"),
 preload("uid://5v3vabyn8m17"),
 preload("uid://gf8vdnija1vd"),
 preload("uid://b24xtp3wjby6f"),
 preload("uid://upwhi02pg6fe"),
 preload("uid://c7bwajc203nhb"),
 preload("uid://dem846g8ngsqi"),
 preload("uid://bon88m23puq0b"),
 preload("uid://bdgygmhxc1ehk"),
 preload("uid://b8dfupmkooag"),
 preload("uid://kkl5mhvouri")]
var chartInstances : Array[TextureRect]
var oldText : String

@export_group("positioning")
@export var spacing : float
enum POSSTART{ left, center, right}
@export var posStart : POSSTART

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

@export_group("effects")
enum EFFECTS{none, flash}
@export var effect : EFFECTS
@export var flashDuration : float
@export var flashsCount   : int

func _ready():
	resetCharachters()

func resetCharachters():
	if chartInstances.size() > 0:
		for c in chartInstances:
			c.queue_free()
			remove_child(c)
	
	chartInstances.clear()
	for i in text.length():
		var chartInstance = charSprite.instantiate()
		add_child(chartInstance)
		chartInstances.append(chartInstance)

func _process(delta: float):
	time += delta
	if text.length() != oldText.length() : resetCharachters()
	
	for i in chartInstances.size():
		var xPos : float = 0 if posStart == POSSTART.left else chartInstances.size() * spacing * 0.5 if posStart == POSSTART.center else chartInstances.size() * spacing
		var charS = chartInstances[i]
		charS.position = Vector2(i * spacing - xPos, 0) + wobbleRange * sin(charS.position.x * wobbleFrequancy + time * wobbleSpeed) * wobbleAxis
		charS.rotation = deg_to_rad(wiggleRange) * sin(charS.position.x * wiggleFrequancy + time * wiggleSpeed)
		if text[i] == " " : charS.texture = null
		else: charS.texture = selectTextures[getTexture(text[i])]
		if text != oldText : runEffect(i)
	oldText = text

func getTexture(char: String):
	for i in selectTextures.size():
		var current : String = selectTextures[i].resource_path[21]
		if current == char: return i
	return 0

func runEffect(index : int):
	var char = chartInstances[index]
	if effect == EFFECTS.flash:
		for i in flashsCount:
			char.modulate = Color(0,0,0,0)
			await get_tree().create_timer(flashDuration * 0.5).timeout
			char.modulate = Color(1,1,1,1)
			await get_tree().create_timer(flashDuration * 0.5).timeout
