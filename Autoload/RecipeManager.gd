extends Node

@export var trash_item : IngredientResource

var recipe_lookup = {}

func _ready() -> void:
	# Preload all ingredients
	var dried_pasta = preload("res://Resources/Dried_Pasta.tres")
	var lettuce = preload("res://Resources/Lettuce.tres")
	var tomato_sauce = preload("res://Resources/Tomato_Sauce.tres")
	var pufferfish = preload("res://Resources/Pufferfish.tres")
	var garlic = preload("res://Resources/Garlic.tres") # end of basic ingredients
	var pasta_salad = preload("res://Resources/Pasta_Salad.tres")
	var cold_pasta_tomato = preload("res://Resources/Cold_Pasta_Tomato.tres")
	var cactus = preload("res://Resources/Cactus.tres")
	var stink_bomb = preload("res://Resources/Stink_Bomb.tres")
	var dragon_fruit = preload("res://Resources/Dragon_Fruit.tres")
	var pineapple = preload("res://Resources/Pineapple.tres") 
	var okonomiyaki = preload("res://Resources/Okonomiyaki.tres")

	# Register all recipes
	register_recipe(dried_pasta, lettuce, pasta_salad)
	register_recipe(dried_pasta, tomato_sauce, cold_pasta_tomato)
	register_recipe(dried_pasta, pufferfish, cactus)
	register_recipe(dried_pasta, garlic, stink_bomb)
	register_recipe(tomato_sauce, lettuce, dried_pasta)
	register_recipe(tomato_sauce, pufferfish, dragon_fruit)
	register_recipe(tomato_sauce, garlic, stink_bomb)
	register_recipe(lettuce, pufferfish, pineapple)
	register_recipe(lettuce, garlic, okonomiyaki)
	register_recipe(pufferfish, garlic, stink_bomb)

"""
Takes two ingredients and registers a recipe for their combination
"""
func register_recipe(ing_a: IngredientResource, ing_b: IngredientResource, result: IngredientResource):
	var key = make_key(ing_a, ing_b)
	recipe_lookup[key] = result
	# Auto-populate components on the result
	result.components = [ing_a, ing_b]

"""
Takes two ingredients and makes a unique key for them
"""
func make_key(ing_a: IngredientResource, ing_b: IngredientResource) -> String:
	var names = [ing_a.get_ingredient_name(), ing_b.get_ingredient_name()]
	names.sort()
	return names[0] + "|" + names[1]


"""
Takes two ingredient scenes, combines them according to the recipes, and spawns the result

"""
func combine(item_a: IngredientScene, item_b: IngredientScene) -> void:
	var ing_a = item_a.ingredient_data
	var ing_b = item_b.ingredient_data
	var result_ingredient: IngredientResource
	var key = make_key(ing_a, ing_b)
	
	# 1) Found the recipe, so return the result
	if recipe_lookup.has(key):
		result_ingredient = recipe_lookup[key]
	
	# 2) Same ingredient, so just return that same ingredient
	elif ing_a == ing_b:
			result_ingredient = ing_a
		
	# 3) Check if one is a component of the other (any depth)
	elif ing_a.contains_ingredient(ing_b):
			result_ingredient = ing_a

	elif ing_b.contains_ingredient(ing_a):
		result_ingredient = ing_b
		
	# Otherwise, resulting ingredient is trash
	else:
		result_ingredient = trash_item 
	
	# Get rid of the two items, and spawn the new one
	spawn_new_item(result_ingredient, ing_a.global_position)
	item_a.queue_free()
	item_b.queue_free()

"""
Spawns a new item of the given ingredient at the given position
"""
func spawn_new_item(ingredient: IngredientResource, position: Vector2) -> void:
	pass