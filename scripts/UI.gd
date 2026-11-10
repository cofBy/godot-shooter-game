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
@export var finalScore : Control
@export var highScore  : Control
var highScoreCNF = ConfigFile.new()

func _ready():
	scoreLabel.visible = true
	lostPanel.visible = false
	lostPanelPos = lostPanel.position
	lostPanel.position = lostPanelPos + Vector2(0, 1200)
	player.died.connect(playerDed)
	
	retryButton.pressed.connect(SOUND.transition.bind("reload"))
	mainMenuButton.pressed.connect(SOUND.transition.bind("res://scenes/main_menu.tscn"))

func _process(_delta: float):
	bulletsLabel.text = str(player.gun.currentBullets) + "-" + str(player.gun.data.magSize)
	scoreLabel.text = str(player.score)
	finalScore.text = "score " + str(player.score)

func playerDed():
	scoreLabel.visible = false
	lostPanel.visible = true
	
	highScoreCNF.load("user://save_data.cfg")
	var currentHighScore : int
	if highScoreCNF.has_section_key("player", "highScore") : currentHighScore = highScoreCNF.get_value("player", "highScore")
	else : currentHighScore = 0
	highScoreCNF.set_value("player", "highScore", max(player.score, currentHighScore))
	highScoreCNF.save("user://save_data.cfg")
	highScore.text = str(highScoreCNF.get_value("player", "highScore"))
	
	var tween : Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(lostPanel, "position", lostPanelPos, lostPaneDur).set_trans(Tween.TRANS_QUAD)
	get_tree().paused = true
