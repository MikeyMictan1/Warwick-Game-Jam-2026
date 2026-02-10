extends Node

var sfx_click: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_bell: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_flood: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_recipe: AudioStreamPlayer = AudioStreamPlayer.new()
var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var game_muted : bool = false

# Track which music is currently playing to avoid restarting
var current_track: String = ""

# Music track paths
const TRACK_MENUS = "res://Assets/Bgm/menus.mp3"
const TRACK_INSTRUCTIONS = "res://Assets/Bgm/instructions.mp3"
const TRACK_MAIN_GAME = "res://Assets/Bgm/main_scene_music.mp3"
const TRACK_WIN = "res://Assets/Bgm/win_music.mp3"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	
	# Start with menu music
	play_track(TRACK_MENUS)
	
	# sfx
	sfx_click.stream = load("res://Assets/Music/click_sfx.mp3")
	add_child(sfx_click)
	
	sfx_bell.stream = load("res://Assets/Music/bell_sfx.mp3")
	add_child(sfx_bell)

	sfx_flood.stream = load("res://Assets/Music/flood_sfx.mp3")
	add_child(sfx_flood)

	sfx_recipe.stream = load("res://Assets/Music/recipe_sfx.mp3")
	add_child(sfx_recipe)

func play_track(track_path: String) -> void:
	# Don't restart if same track is already playing
	if current_track == track_path and music_player.playing:
		return
	
	var stream = load(track_path)
	if stream is AudioStream:
		if stream is AudioStreamMP3:
			stream.loop = true
		music_player.stream = stream
		music_player.play()
		current_track = track_path
	

func play_menu_music():
	play_track(TRACK_MENUS)

func play_instructions_music():
	play_track(TRACK_INSTRUCTIONS)

func play_main_game_music():
	play_track(TRACK_MAIN_GAME)

func play_win_music():
	play_track(TRACK_WIN)

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
	
