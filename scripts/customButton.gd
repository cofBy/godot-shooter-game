extends BaseButton

@export_group("visuals")
@export var defultRect : NinePatchRect
@export var pressedRect : NinePatchRect

func _ready():
	mouse_entered.connect(SOUND.playSound.bind("hover"))
	button_down.connect(SOUND.playSound.bind("click"))

func _process(_delta: float):
	defultRect.visible = !button_pressed
	pressedRect.visible = button_pressed
