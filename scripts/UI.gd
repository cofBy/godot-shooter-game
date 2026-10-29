extends Control

@export_group("data")
@export var player: Node2D

@export_group("bullets")
@export var bulletsLabel : Control

func _process(delta: float):
	bulletsLabel.text = str(player.gun.currentBullets) + "-" + str(player.gun.data.magSize)
