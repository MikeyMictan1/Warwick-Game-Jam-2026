extends Node

var trash_item : IngredientResource = preload("res://Resources/Trash.tres")
const INGREDIENT_SCENE = preload("res://Scenes/Ingredient.tscn")

var recipe_lookup = {}

func _ready() -> void:
	# Preload all ingredients
	var dried_pasta = preload("res://Resources/Dried_Pasta.tres")
	var lettuce = preload("res://Resources/Lettuce.tres")
	var tomato_sauce = preload("res://Resources/Tomato_Sauce.tres")
	var pufferfish = preload("res://Resources/Pufferfish.tres")
	var garlic = preload("res://Resources/Garlic.tres")
	var pasta_salad = preload("res://Resources/Pasta_Salad.tres")
	var cold_pasta_tomato = preload("res://Resources/Cold_Pasta_Tomato.tres")
	var cactus = preload("res://Resources/Cactus.tres")
	var stink_bomb = preload("res://Resources/Stink_Bomb.tres")
	var dragon_fruit = preload("res://Resources/Dragon_Fruit.tres")
	var pineapple = preload("res://Resources/Pineapple.tres")
	var okonomiyaki = preload("res://Resources/Okonomiyaki.tres")
	var pineapple_jam = preload("res://Resources/Pineapple_Jam.tres")
	var komodo_dragon = preload("res://Resources/Komodo_Dragon.tres")
	var real_bomb = preload("res://Resources/Real_Bomb.tres")
	var burnt_pasta = preload("res://Resources/Burnt_Pasta.tres")
	var ice_cream = preload("res://Resources/Ice_Cream.tres")
	var pufferfish_milk = preload("res://Resources/Pufferfish_Milk.tres")
	var ai = preload("res://Resources/AI.tres")
	var alive_pufferfish = preload("res://Resources/Alive_Pufferfish.tres")
	var arranccinni = preload("res://Resources/Arranccinni.tres")
	var bomb_picture = preload("res://Resources/Bomb_Picture.tres")
	var cabbage = preload("res://Resources/Cabbage.tres")
	var carmelised_onion = preload("res://Resources/Carmelised_Onion.tres")
	var cooked_lettuce = preload("res://Resources/Cooked_Lettuce.tres")
	var cooked_pasta = preload("res://Resources/Cooked_Pasta.tres")
	var croutons = preload("res://Resources/Croutons.tres")
	var dragon_roll = preload("res://Resources/Dragon_Roll.tres")
	var feet = preload("res://Resources/Feet.tres")
	var garlic_bread = preload("res://Resources/Garlic_Bread.tres")
	var garlic_oil = preload("res://Resources/Garlic_Oil.tres")
	var garlic_pasta = preload("res://Resources/Garlic_Pasta.tres")
	var intellagama_lesueurii = preload("res://Resources/Intellagama_Lesueurii.tres")
	var onion_rings = preload("res://Resources/Onion_Rings.tres")
	var pasta_sauce = preload("res://Resources/Pasta_Sauce.tres")
	var petroleum = preload("res://Resources/Petroleum.tres")
	var pineapple_pizza = preload("res://Resources/Pineapple_Pizza.tres")
	var pizza_base = preload("res://Resources/Pizza_Base.tres")
	var red_onion = preload("res://Resources/Red_Onion.tres")
	var sponge = preload("res://Resources/Sponge.tres")
	var spring_rolls = preload("res://Resources/Spring_Rolls.tres")
	var stuffed_pasta = preload("res://Resources/Stuffed_Pasta.tres")
	var tomato_pasta = preload("res://Resources/Tomato_Pasta.tres")
	var tomato_pizza = preload("res://Resources/Tomato_Pizza.tres")
	var tomato_soup = preload("res://Resources/Tomato_Soup.tres")
	var trash = preload("res://Resources/Trash.tres")
	var ultimate_pasta = preload("res://Resources/Ultimate_Pasta.tres")
	var water = preload("res://Resources/Water.tres")
	var white_onion = preload("res://Resources/White_Onion.tres")
	var cold_pasta_sauce = preload("res://Resources/Cold_Pasta_Sauce.tres")

	# Register all recipes ---------------------------------
	# First Degree Recipes
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

	# Pasta Combination Recipes
	register_recipe(cooked_pasta, garlic_pasta, ultimate_pasta)
	register_recipe(cooked_pasta, pasta_salad, ultimate_pasta)
	register_recipe(cooked_pasta, cold_pasta_tomato, ultimate_pasta)
	register_recipe(garlic_pasta, pasta_salad, ultimate_pasta)
	register_recipe(garlic_pasta, cold_pasta_tomato, ultimate_pasta)
	register_recipe(pasta_salad, cold_pasta_tomato, ultimate_pasta)

	# Second Degree Recipes
	register_recipe(cold_pasta_tomato, garlic, stuffed_pasta)
	register_recipe(cold_pasta_tomato, lettuce, spring_rolls)
	register_recipe(cold_pasta_tomato, pufferfish, dragon_roll)
	register_recipe(cold_pasta_tomato, garlic_oil, arranccinni)
	register_recipe(dragon_fruit, lettuce, red_onion)
	register_recipe(red_onion, tomato_sauce, tomato_sauce)
	register_recipe(red_onion, dried_pasta, onion_rings)
	register_recipe(red_onion, garlic, spring_rolls)
	register_recipe(pasta_salad, tomato_sauce, tomato_soup)
	register_recipe(pasta_salad, pufferfish, croutons)
	register_recipe(pasta_salad, garlic, feet)
	register_recipe(garlic_pasta, tomato_sauce, tomato_soup)

	# Special Recipes
	register_recipe(pineapple, tomato_pizza, pineapple_pizza)
	register_recipe(pizza_base, tomato_sauce, tomato_pizza)
	register_recipe(pizza_base, garlic, garlic_bread)
	register_recipe(pizza_base, red_onion, onion_rings)

	# Final Recipe
	register_recipe(cooked_lettuce, tomato_sauce, red_onion)
	register_recipe(red_onion, garlic_oil, carmelised_onion)
	register_recipe(carmelised_onion, tomato_sauce, cold_pasta_sauce)
	register_recipe(cooked_pasta, pasta_sauce, tomato_pasta)

	# EXTRA RECIPES
	register_recipe(cold_pasta_tomato, tomato_sauce, tomato_soup)
	register_recipe(pufferfish, pufferfish_milk, alive_pufferfish)
	register_recipe(pineapple, cactus, pineapple_jam)
	register_recipe(dragon_fruit, cactus, komodo_dragon)
	register_recipe(stink_bomb, komodo_dragon, real_bomb)
	register_recipe(cooked_pasta, garlic_oil, garlic_pasta)
	register_recipe(pufferfish, water, alive_pufferfish)
	register_recipe(pufferfish, petroleum, pufferfish_milk)
	register_recipe(dragon_fruit, ai, intellagama_lesueurii)
	register_recipe(stink_bomb, bomb_picture, real_bomb)

"""
Takes two ingredients and registers a recipe for their combination
"""
func register_recipe(ing_a: IngredientResource, ing_b: IngredientResource, result: IngredientResource):
	var key = make_key(ing_a, ing_b)
	recipe_lookup[key] = result
	# Auto-populate components on the result
	result.components.append(ing_a)
	result.components.append(ing_b)

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
	
	# 1) If same ingredient then just return that same ingredient
	if ing_a.get_ingredient_name() == ing_b.get_ingredient_name():
		result_ingredient = ing_a
		
	# 2) Found the recipe, so return the result
	elif recipe_lookup.has(key):
		result_ingredient = recipe_lookup[key]
		
	# 3) Check if one is a component of the other (any depth)
	elif ing_a.contains_ingredient(ing_b):
		result_ingredient = ing_a

	elif ing_b.contains_ingredient(ing_a):
		result_ingredient = ing_b

	# Otherwise, resulting ingredient is trash
	else:
		result_ingredient = trash_item 
	
	# Get rid of the two items, and spawn the new one
	spawn_new_item(result_ingredient, item_a.global_position)
	item_a.queue_free()
	item_b.queue_free()

"""
Takes two ingredient scenes, combines them with a pop animation at specified position
Used for mixing bowl combinations
"""
func combine_with_pop(item_a: IngredientScene, item_b: IngredientScene, spawn_position: Vector2) -> void:
	var ing_a = item_a.ingredient_data
	var ing_b = item_b.ingredient_data
	var result_ingredient: IngredientResource
	var key = make_key(ing_a, ing_b)
	
	# 1) If same ingredient then just return that same ingredient
	if ing_a.get_ingredient_name() == ing_b.get_ingredient_name():
		result_ingredient = ing_a
		
	# 2) Found the recipe, so return the result
	elif recipe_lookup.has(key):
		result_ingredient = recipe_lookup[key]
		
	# 3) Check if one is a component of the other (any depth)
	elif ing_a.contains_ingredient(ing_b):
		result_ingredient = ing_a

	elif ing_b.contains_ingredient(ing_a):
		result_ingredient = ing_b

	# Otherwise, resulting ingredient is trash
	else:
		result_ingredient = trash_item 
	
	# Get rid of the two items, and spawn the new one with pop animation
	spawn_new_item(result_ingredient, spawn_position, true)
	item_a.queue_free()
	item_b.queue_free()

"""
Spawns a new IngredientScene of the given ingredient at the given position
"""
func spawn_new_item(ingredient: IngredientResource, position: Vector2, use_pop_animation: bool = false) -> IngredientScene:
	var new_item = INGREDIENT_SCENE.instantiate()
	new_item.ingredient_data = ingredient
	new_item.global_position = position
	print("Created: ", ingredient.get_ingredient_name())
	get_tree().current_scene.add_child(new_item)
	
	if use_pop_animation:
		new_item.pop_out()
	
	return new_item

""""
Adds an ingredient to the oven, and cooks it after 3 seconds
"""
func combine_oven(ingredient : IngredientScene):
	pass

""""
Adds an ingredient to the washing machine, and washes it after 2 seconds
"""
func combine_washing(ingredient : IngredientScene):
	pass
