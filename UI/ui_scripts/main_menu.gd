extends Node2D

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/ui_scenes/ControlsMenu.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/ui_scenes/CreditsMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
