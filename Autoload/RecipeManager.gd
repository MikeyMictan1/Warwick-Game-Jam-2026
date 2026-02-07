extends Node

var trash_item : IngredientResource = preload("res://Resources/Trash.tres")
const INGREDIENT_SCENE = preload("res://Scenes/Ingredient.tscn")
const KITCHEN_EXPLOSION = preload("res://Scenes/KitchenExplosion.tscn")

# Dummy resources for appliances to use in recipes
var oven_appliance: IngredientResource
var washing_appliance: IngredientResource

var recipe_lookup = {}

func _ready() -> void:
	# Create dummy appliance resources
	oven_appliance = IngredientResource.new()
	oven_appliance.name = "_OVEN_"
	washing_appliance = IngredientResource.new()
	washing_appliance.name = "_WASHING_"
	
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

	# events
	var event_explosion = preload("res://Resources/Event_Explosion.tres")
	var event_flood = preload("res://Resources/Event_Flood.tres")
	var event_boiling = preload("res://Resources/Event_Boiling.tres")

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
	register_recipe(water, dried_pasta, cooked_pasta)
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
	
	# Oven Recipes
	register_recipe(garlic, oven_appliance, garlic_oil) # and stench
	register_recipe(tomato_sauce, oven_appliance, event_explosion)
	register_recipe(pufferfish, oven_appliance, pufferfish_milk)
	register_recipe(lettuce, oven_appliance, cooked_lettuce)
	register_recipe(dried_pasta, oven_appliance, burnt_pasta)
	register_recipe(bomb_picture, oven_appliance, real_bomb)
	register_recipe(cold_pasta_tomato, oven_appliance, burnt_pasta)
	register_recipe(dragon_fruit, oven_appliance, komodo_dragon)
	register_recipe(pineapple, oven_appliance, pineapple_jam)
	register_recipe(garlic_oil, oven_appliance, event_explosion)
	register_recipe(red_onion, oven_appliance, water)
	register_recipe(sponge, oven_appliance, water)
	register_recipe(cooked_lettuce, oven_appliance, carmelised_onion)
	register_recipe(garlic_pasta, oven_appliance, ultimate_pasta)
	register_recipe(pasta_salad, oven_appliance, ultimate_pasta)
	register_recipe(cold_pasta_tomato, oven_appliance, ultimate_pasta)
	register_recipe(cold_pasta_sauce, oven_appliance, pasta_sauce)

	# Washing Machine Recipes
	register_recipe(cooked_pasta, washing_appliance, pizza_base)
	register_recipe(pasta_salad, washing_appliance, pizza_base)
	register_recipe(garlic_pasta, washing_appliance, pizza_base)
	register_recipe(cold_pasta_tomato, washing_appliance, pizza_base)
	register_recipe(burnt_pasta, washing_appliance, pizza_base)
	register_recipe(dried_pasta, washing_appliance, pizza_base)
	register_recipe(ultimate_pasta, washing_appliance, pizza_base)
	register_recipe(stuffed_pasta, washing_appliance, pizza_base)
	register_recipe(sponge, washing_appliance, water)
	register_recipe(lettuce, washing_appliance, cabbage)
	register_recipe(pufferfish, washing_appliance, alive_pufferfish)
	register_recipe(garlic, washing_appliance, garlic_oil)
	register_recipe(dragon_fruit, washing_appliance, intellagama_lesueurii)
	register_recipe(pineapple, washing_appliance, sponge)
	register_recipe(sponge, washing_appliance, event_flood)
	register_recipe(garlic_oil, washing_appliance, event_explosion)
	register_recipe(red_onion, washing_appliance, white_onion)
	register_recipe(white_onion, washing_appliance, red_onion)
	register_recipe(cooked_lettuce, washing_appliance, lettuce)
	register_recipe(pufferfish_milk, washing_appliance, ice_cream)
	register_recipe(carmelised_onion, washing_appliance, onion_rings)

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
func combine_oven(ingredient: IngredientScene, oven_position: Vector2) -> void:
	var ing = ingredient.ingredient_data
	var key = make_key(ing, oven_appliance)
	var result_ingredient: IngredientResource

	
	# Check if there's an oven recipe
	if recipe_lookup.has(key):
		result_ingredient = recipe_lookup[key]
	else:
		# If no recipe, burn it (trash)
		result_ingredient = trash_item
	
	# Remove the ingredient
	ingredient.queue_free()
	
	# Event Hndling -------------------
	event_handler(result_ingredient)
	
	# Wait 3 seconds then spawn result with pop animation
	await get_tree().create_timer(3.0).timeout
	spawn_new_item(result_ingredient, oven_position, true)

""""
Adds an ingredient to the washing machine, and washes it after 2 seconds
"""
func combine_washing(ingredient: IngredientScene, washing_position: Vector2) -> void:
	var ing = ingredient.ingredient_data
	var key = make_key(ing, washing_appliance)
	var result_ingredient: IngredientResource
	
	# Check if there's a washing recipe
	if recipe_lookup.has(key):
		result_ingredient = recipe_lookup[key]
	else:
		# If no recipe, just return water (or just do trash)
		result_ingredient = preload("res://Resources/Water.tres")

	# Remove the ingredient
	ingredient.queue_free()

	# Event Hndling -------------------
	event_handler(result_ingredient)
	
	# Wait 2 seconds then spawn result with pop animation
	await get_tree().create_timer(2.0).timeout
	spawn_new_item(result_ingredient, washing_position, true)

"""
Handles events e.g. kitchen explosion, flood, smell, etc.
"""
func event_handler(result_ingredient : IngredientResource):
	# explodes the ktichen
	if result_ingredient.get_ingredient_name() == "event_explosion":
		explode_kitchen()
	
	# floods the kitchen
	elif result_ingredient.get_ingredient_name() == "event_flood":
		flood_kitchen()


"""
Event for a kitchen explosion
"""
func explode_kitchen():
	var explosion_scene = KITCHEN_EXPLOSION.instantiate()
	get_tree().current_scene.add_child(explosion_scene)
	explosion_scene.run()

"""
Event for a kitchen flood
"""
func flood_kitchen():
	# var flood_scene = KITCHEN_FLOOD.instantiate()
	# get_tree().current_scene.add_child(flood_scene)
	# flood_scene.run()
	pass
