extends NinePatchRect

@export_group("start")
@export var playButton : Button
const WORLD = preload("uid://byrw8k2j3tbhl")

func _process(delta: float):
	if playButton.button_pressed == true: get_tree().change_scene_to_packed(WORLD)
