extends Area2D

var held_ingredient: IngredientScene = null
@export var tomato_pasta : IngredientScene

func _ready():
	add_to_group("finished_plate")

func submitted():
	if not held_ingredient:
		return
	
	elif held_ingredient:
		if held_ingredient.get_ingredient_name() == "Tomato_Pasta":
			get_tree().change_scene_to_file("res://UI/ui_scenes/WinningMenu.tscn")

		held_ingredient.kill_ingredient()

# Call this to add an ingredient to Finished
func add_ingredient(ingredient: IngredientScene):
	if held_ingredient == null:
		held_ingredient = ingredient
		# Snap ingredient to Finished position
		ingredient.global_position = global_position
		ingredient.z_index = 1
		# Stop ingredient timer
		if ingredient.timer:
			ingredient.timer.stop()
		print("Ingredient added to Finished.")
		return true
	else:
		print("Finished already holding an ingredient.")
		return false

func remove_ingredient():
	if held_ingredient:
		# Restart timers when removed
		held_ingredient.start_timers()
		held_ingredient = null
		print("Ingredient removed from Finished.")
