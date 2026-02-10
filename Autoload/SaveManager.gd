extends Node

const SAVE_PATH = "user://recipe_progress.save"
const SETTINGS_PATH = "user://settings.save"

# Settings
var screen_shake_enabled: bool = true
var resolution: Vector2i = Vector2i(1920, 1080)

func _ready() -> void:
	# Load settings on startup
	load_settings()
	apply_resolution()

# BOILERPLATE SAVE LOGICCC WIULL REPLACE FOR RECUPIES SOON
func save_progress(discovered_ingredients: Array[String]):
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"discovered_ingredients": discovered_ingredients
		}
		save_file.store_var(save_data)
		save_file.close()


func load_progress() :
	if not FileAccess.file_exists(SAVE_PATH):
		return []
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file:
		var save_data = save_file.get_var()
		save_file.close()
		if save_data and save_data.has("discovered_ingredients"):
			return save_data["discovered_ingredients"]
	return []

func reset_progress():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func save_settings() -> void:
	var save_file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"screen_shake_enabled": screen_shake_enabled,
			"resolution_w": resolution.x,
			"resolution_h": resolution.y
		}
		save_file.store_var(save_data)
		save_file.close()


func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	
	var save_file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if save_file:
		var save_data = save_file.get_var()
		save_file.close()
		if save_data:
			if save_data.has("screen_shake_enabled"):
				screen_shake_enabled = save_data["screen_shake_enabled"]
			if save_data.has("resolution_w") and save_data.has("resolution_h"):
				resolution = Vector2i(save_data["resolution_w"], save_data["resolution_h"])

func apply_resolution() -> void:
	DisplayServer.window_set_size(resolution)
	# Center the window on screen
	var screen_size = DisplayServer.screen_get_size()
	var window_pos = (screen_size - resolution) / 2
	DisplayServer.window_set_position(window_pos)

func toggle_resolution() -> void:
	if resolution == Vector2i(1920, 1080):
		resolution = Vector2i(1280, 720)
	else:
		resolution = Vector2i(1920, 1080)
	apply_resolution()
	save_settings()
