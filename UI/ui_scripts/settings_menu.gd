extends Node2D

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/ui_scenes/MainMenu.tscn")

func _on_reset_progress_pressed() -> void:
	pass # Replace with function body.
