class_name soundEffect
extends Resource

@export var streams : Array[AudioStream]
@export var soundName : String
@export_range(0.0, 1.0, 0.05) var minVolume : float
@export_range(0.0, 1.0, 0.05) var maxVolume : float
@export_range(0.0, 4.0, 0.05) var minPitch  : float
@export_range(0.0, 4.0, 0.05) var maxPitch  : float
