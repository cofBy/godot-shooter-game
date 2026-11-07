extends NinePatchRect

@export_group("start")
@export var playButton : Button

func _ready():
	playButton.pressed.connect(SOUND.transition.bind("res://scenes/world.tscn"))
