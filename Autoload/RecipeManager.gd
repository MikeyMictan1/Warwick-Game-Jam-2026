extends Node

@export var trash_item : IngredientResource

# Of form : {"Ingr1+Ingr2": IngredientResource}
var recipe_lookup = {
	
}

func combine(item_a: IngredientScene, item_b: IngredientScene):
	var data_a = item_a.ingredient_data
	var data_b = item_b.ingredient_data
	
	# Ask the Manager what these two make
	var result_data = RecipeManager.get_mix_result(data_a, data_b)
	
	if result_data != RecipeManager.trash_item:
		#spawn_new_item(result_data, item_a.global_position)
		item_a.queue_free()
		item_b.queue_free()
