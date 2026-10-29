extends NinePatchRect

@export_group("start")
@export var playButton : Button
@export var gameScene : PackedScene

func _process(delta: float):
	if playButton.button_pressed == true: get_tree().change_scene_to_packed(gameScene)
