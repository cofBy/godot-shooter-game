extends Control

@export_group("data")
@export var player: Node2D

@export_group("UI elements")
@export var bulletsLabel : Control
@export var lostPanel : NinePatchRect
@export var lostPaneDur : float
var lostPanelPos : Vector2
@export var retryButton: Button
@export var mainMenuButton: Button
@export var scoreLabel : Control

func _ready():
	lostPanel.visible = false
	lostPanelPos = lostPanel.position
	lostPanel.position = lostPanelPos + Vector2(0, 1200)
	player.died.connect(playerDed)
	
	retryButton.pressed.connect(SOUND.transition.bind("reload"))
	mainMenuButton.pressed.connect(SOUND.transition.bind("res://scenes/main_menu.tscn"))

func _process(_delta: float):
	bulletsLabel.text = str(player.gun.currentBullets) + "-" + str(player.gun.data.magSize)
	scoreLabel.text = str(player.score)

func playerDed():
	lostPanel.visible = true
	var tween : Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(lostPanel, "position", lostPanelPos, lostPaneDur).set_trans(Tween.TRANS_QUAD)
	get_tree().paused = true
