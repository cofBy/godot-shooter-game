extends Control

@export_group("data")
@export var player: Node2D

@export_group("UI elements")
@export var bulletsLabel : Control
@export var lostPanel : NinePatchRect
@export var retryButton: Button
@export var mainMenuButton: Button

func _process(delta: float):
	bulletsLabel.text = str(player.gun.currentBullets) + "-" + str(player.gun.data.magSize)
	
	lostPanel.visible = player.isDead
	get_tree().paused = player.isDead
	
	if retryButton.button_pressed == true:
		get_tree().reload_current_scene()
	if mainMenuButton.button_pressed == true:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
