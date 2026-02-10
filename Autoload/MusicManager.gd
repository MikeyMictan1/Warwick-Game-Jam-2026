extends Node

var sfx_click: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_bell: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_flood: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var music_player = AudioStreamPlayer.new()
	add_child(music_player)
	var stream = load("res://Assets/Music/bg_music.mp3")
	if stream is AudioStream:
		if stream.has_method("set_loop"):
			stream.set_loop(true)
		elif stream is AudioStreamMP3:
			stream.loop = true
	music_player.stream = stream
	music_player.play()
	
	# sfx
	sfx_click.stream = load("res://Assets/Music/click_sfx.mp3")
	add_child(sfx_click)
	
	sfx_bell.stream = load("res://Assets/Music/bell_sfx.mp3")
	add_child(sfx_bell)

	sfx_flood.stream = load("res://Assets/Music/flood_sfx.mp3")
	add_child(sfx_flood)

func play_click_sfx():
	sfx_click.play()

func play_bell_sfx():
	sfx_bell.play()

func play_flood_sfx():
	sfx_flood.play()

func lower_music_volume():
	var music_player = get_node_or_null("AudioStreamPlayer")
	if music_player:
		music_player.volume_db = -20  # Lower volume by 20 dB

func increase_music_volume():
	var music_player = get_node_or_null("AudioStreamPlayer")
	if music_player:
		music_player.volume_db = 0  # Reset to original volume
