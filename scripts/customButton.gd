extends BaseButton

@export_group("visuals")
@export var defultRect : NinePatchRect
@export var pressedRect : NinePatchRect

func _process(delta: float):
	defultRect.visible = !button_pressed
	pressedRect.visible = button_pressed
