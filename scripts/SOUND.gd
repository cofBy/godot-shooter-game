extends Node2D

const streamPlayer = preload("uid://b1bmxpfsb530k")

@export_group("sound effects")
@export var streams : Array[soundEffect]
var streamPlayers : Array[AudioStreamPlayer]
var rng = RandomNumberGenerator.new()

func _ready():
	for strm in streams:
		var streamPlayerInstance : AudioStreamPlayer = streamPlayer.instantiate()
		streamPlayers.append(streamPlayerInstance)
		add_child(streamPlayerInstance)

func playSound(soundName : String):
	for i in streams.size():
		if streams[i].soundName == soundName:
			var strm = streams[i]
			streamPlayers[i].stream = strm.streams[rng.randi_range(0, strm.streams.size() - 1)]
			streamPlayers[i].volume_linear = rng.randf_range(strm.minVolume, strm.maxVolume)
			streamPlayers[i].pitch_scale   = rng.randf_range(strm.minPitch, strm.maxPitch)
			streamPlayers[i].play()
			return
