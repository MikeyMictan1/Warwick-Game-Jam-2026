extends Node

# MusicManager: Plays background music across all scenes, looping 24/7

var music_player: AudioStreamPlayer
var music_path := "res://Assets/Music/" # Path to your music folder
var music_file := "" # Set this to your music file name, e.g., "background.ogg"

func _ready():
	# If you have only one music file, auto-detect it
	if music_file == "":
		var dir = DirAccess.open(music_path)
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir() and file_name.ends_with(".ogg") or file_name.ends_with(".mp3") or file_name.ends_with(".wav"):
					music_file = file_name
					break
				file_name = dir.get_next()
			dir.list_dir_end()
	if music_file == "":
		push_error("No music file found in " + music_path)
		return

	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	var stream = load(music_path + music_file)
	# Set looping on the stream if possible
	if stream is AudioStream:
		if stream.has_method("set_loop"):
			stream.set_loop(true)
		elif stream is AudioStreamOggVorbis or stream is AudioStreamMP3 or stream is AudioStreamWAV:
			stream.loop = true
	music_player.stream = stream
	music_player.autoplay = true
	# Set to 'Music' bus if it exists, otherwise use 'Master'
	var bus_name = "Master"
	for i in AudioServer.get_bus_count():
		var name = AudioServer.get_bus_name(i)
		if name == "Music":
			bus_name = "Music"
			break
	music_player.bus = bus_name
	music_player.stream_paused = false
	music_player.volume_db = 0
	music_player.play()

	# Ensure this node persists across scenes
	set_process(false)
	get_tree().get_root().add_child(self)
	self.owner = null
