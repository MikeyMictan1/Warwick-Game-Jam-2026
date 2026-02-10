extends Node2D

@onready var explosion_text : RichTextLabel = $CanvasLayer/Control/ExplosionText

func _ready() -> void:
	# displays the custom message onto the explsiion menu
	var message = RecipeManager.explosion_message
	explosion_text.text = message

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/ui_scenes/MainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
