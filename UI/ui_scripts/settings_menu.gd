extends Node2D

@onready var screen_shake_button: CheckButton = $CanvasLayer/Control/ScreenShakeButton

func _ready() -> void:
	# Update button state to match current setting
	if screen_shake_button:
		screen_shake_button.button_pressed = not SaveManager.screen_shake_enabled

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/ui_scenes/MainMenu.tscn")

func _on_reset_progress_pressed() -> void:
	# Reset saved progress
	SaveManager.reset_progress()
	
	# Find and clear the recipe book if it exists
	var recipe_book = get_tree().get_first_node_in_group("recipe_book")
	if recipe_book:
		recipe_book.clear_progress()
	


func _on_screen_shake_button_pressed() -> void:
	# Button text is "Disable Screen Shake", so button_pressed means disabled
	SaveManager.screen_shake_enabled = not screen_shake_button.button_pressed
	SaveManager.save_settings()


func _on_mute_button_pressed() -> void:
	MusicManager.mute()
