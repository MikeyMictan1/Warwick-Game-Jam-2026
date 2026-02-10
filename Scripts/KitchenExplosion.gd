extends CanvasLayer
@onready var anim : AnimationPlayer = $AnimationPlayer

func run():
	# still need to add the actual animations
	anim.play("explode")

func explosion_menu():
	get_tree().change_scene_to_file("res://UI/ui_scenes/ExplosionMenu.tscn")
