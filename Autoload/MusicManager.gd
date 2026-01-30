extends Node

func _ready():
	var music_player = AudioStreamPlayer.new()
	add_child(music_player)
	var stream = load("res://Assets/Music/bg_music.mp3")
	if stream is AudioStream:
		if stream.has_method("set_loop"):
			stream.set_loop(true)
		elif stream is AudioStreamMP3 or stream is AudioStreamOggVorbis or stream is AudioStreamWAV:
			stream.loop = true
	music_player.stream = stream
	music_player.play()
