extends Node

var sfx_click: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_bell: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_flood: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_recipe: AudioStreamPlayer = AudioStreamPlayer.new()
var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var game_muted : bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
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

	sfx_recipe.stream = load("res://Assets/Music/recipe_sfx.mp3")
	add_child(sfx_recipe)

func play_click_sfx():
	sfx_click.play()

func play_bell_sfx():
	sfx_bell.play()

func play_flood_sfx():
	sfx_flood.play()

func play_recipe_sfx():
	sfx_recipe.play()

func lower_music_volume():
	if music_player:
		music_player.volume_db = -20  

func increase_music_volume():
	if music_player:
		music_player.volume_db = 0  

func mute():
	if music_player and music_player.volume_db == -80:
		music_player.volume_db = 0
	elif music_player:
		music_player.volume_db = -80
	
