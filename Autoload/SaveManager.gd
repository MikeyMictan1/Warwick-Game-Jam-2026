extends Node

const SAVE_PATH = "user://recipe_progress.save"
const SETTINGS_PATH = "user://settings.save"

# Settings
var screen_shake_enabled: bool = true

func _ready() -> void:
	# Load settings on startup
	load_settings()

# BOILERPLATE SAVE LOGICCC WIULL REPLACE FOR RECUPIES SOON
func save_progress(discovered_ingredients: Array[String]):
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"discovered_ingredients": discovered_ingredients
		}
		save_file.store_var(save_data)
		save_file.close()
		print("Progress saved: ", discovered_ingredients.size(), " ingredients")

func load_progress() :
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")
		return []
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file:
		var save_data = save_file.get_var()
		save_file.close()
		if save_data and save_data.has("discovered_ingredients"):
			print("Progress loaded: ", save_data["discovered_ingredients"].size(), " ingredients")
			return save_data["discovered_ingredients"]
	return []

func reset_progress():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("Progress reset")
	else:
		print("No save file to reset")

func save_settings() -> void:
	var save_file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"screen_shake_enabled": screen_shake_enabled
		}
		save_file.store_var(save_data)
		save_file.close()
		print("Settings saved")

func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		print("No settings file found, using defaults")
		return
	
	var save_file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if save_file:
		var save_data = save_file.get_var()
		save_file.close()
		if save_data:
			if save_data.has("screen_shake_enabled"):
				screen_shake_enabled = save_data["screen_shake_enabled"]
			print("Settings loaded")
