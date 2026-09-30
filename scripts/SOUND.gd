extends Node2D

const streamPlayer = preload("uid://b1bmxpfsb530k")

@export_group("sound effects")
@export var streams : Array[soundEffect]
var streamPlayerInstance : AudioStreamPlayer
var rng = RandomNumberGenerator.new()

func _ready():
	streamPlayerInstance = streamPlayer.instantiate()
	add_child(streamPlayerInstance)

func playSound(soundName : String):
	for strm in streams:
		if strm.soundName == soundName:
			streamPlayerInstance.stream = strm.streams[rng.randi_range(0, strm.streams.size() - 1)]
			streamPlayerInstance.volume_linear = rng.randf_range(strm.minVolume, strm.maxVolume)
			streamPlayerInstance.pitch_scale   = rng.randf_range(strm.minPitch, strm.maxPitch)
			streamPlayerInstance.play()
			return
