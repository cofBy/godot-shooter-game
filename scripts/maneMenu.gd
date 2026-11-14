extends NinePatchRect

@export_group("character select")
@export var playButton : Button
@export var charSelectPanel : NinePatchRect
@export var characters : Array[Button]

func _ready():
	charSelectPanel.scale.y = 0
	playButton.pressed.connect(showCharSelect)
	for b in characters.size() : characters[b].button_down.connect(selectChar.bind(b))

func _process(_delta: float):
	for b in characters.size() :
		characters[b].get_child(0).visible = characters[b].is_hovered()

func showCharSelect():
	if playButton.button_pressed == false: playButton.button_pressed = true
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(charSelectPanel, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_QUAD)

func selectChar(index : int):
	SOUND.selectedCharacter = index
	SOUND.transition("res://scenes/world.tscn")
