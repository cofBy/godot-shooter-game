extends Node2D

const streamPlayer = preload("uid://b1bmxpfsb530k")

@export_group("sound effects")
@export var streams : Array[soundEffect]
var streamPlayers : Array[AudioStreamPlayer]
var rng = RandomNumberGenerator.new()

@export_group("transition")
@export var trans : PackedScene
@export var transDuration : float
@export var blackOutTimeFrames : int
var cam: Camera2D
var transTimer : float
var transInstance


func _ready():
	transTimer = 0.0
	for strm in streams:
		var streamPlayerInstance : AudioStreamPlayer = streamPlayer.instantiate()
		streamPlayers.append(streamPlayerInstance)
		add_child(streamPlayerInstance)
	
	transition.call_deferred(null, true)

func transition(scene : Variant = null, onStart : bool = false):
	if onStart : playSound("trans", 0.5)
	else       : playSound("trans", 0.0)
	
	cam = get_viewport().get_camera_2d()
	get_tree().paused = true
	transInstance = trans.instantiate()
	transInstance.scale = Vector2.ONE * 0.2 / cam.zoom.x
	transInstance.position = cam.position
	get_tree().root.add_child(transInstance)
	transTimer = transDuration + (transDuration * transInstance.material.get_shader_parameter("outerColorRange"))

	while transTimer > -transDuration * transInstance.material.get_shader_parameter("outerColorRange"):
		transTimer -= get_process_delta_time()
		if onStart : transInstance.material.set_shader_parameter("transTime", 1.0 - transTimer / transDuration)
		else : transInstance.material.set_shader_parameter("transTime", transTimer / transDuration)
		await get_tree().process_frame
	if onStart == false : for f in blackOutTimeFrames: await get_tree().process_frame
	
	get_tree().paused = false
	transInstance.queue_free()
	transInstance = null
	
	if scene != null:
		if   scene is String and scene == "reload" : get_tree().reload_current_scene()
		elif scene is String     : get_tree().change_scene_to_file  (scene)
		elif scene is PackedScene: get_tree().change_scene_to_packed(scene)

func cameraShake(shakeMaxDist : float, shakeDuration : float):
	cam = get_viewport().get_camera_2d()
	var shakeTimer : float = 0
	while shakeTimer < shakeDuration:
		shakeTimer += get_process_delta_time()
		var angle : float = rng.randf() * PI
		cam.offset = Vector2(cos(angle), sin(angle)) * shakeMaxDist
		await get_tree().process_frame
	cam.offset = Vector2.ZERO

func playSound(soundName : String, customPitch : float = 0.0):
	for i in streams.size():
		if streams[i].soundName == soundName:
			var strm = streams[i]
			streamPlayers[i].stream = strm.streams[rng.randi_range(0, strm.streams.size() - 1)]
			streamPlayers[i].volume_linear = rng.randf_range(strm.minVolume, strm.maxVolume)
			streamPlayers[i].pitch_scale   = rng.randf_range(strm.minPitch, strm.maxPitch) + customPitch
			streamPlayers[i].play()
			return
