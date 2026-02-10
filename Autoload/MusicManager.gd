extends Node

var sfx_click: AudioStreamPlayer = AudioStreamPlayer.new()

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

func play_click_sfx():
	sfx_click.play()
