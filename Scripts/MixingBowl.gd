extends Area2D

var ingredients_in_bowl: Array[IngredientScene] = []
var shader_material: ShaderMaterial
const MIXING_BOWL_OFFSET : int = -50 # offset to move the icon of items inside the mixing bowl

@onready var sprite: AnimatedSprite2D = $Sprite2D

func _ready():
	input_pickable = false
	
	# Setup outline shader
	var shader = preload("res://Assets/Art/outline.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	sprite.material = shader_material
	
	# Connect area signals to detect when ingredients hover over
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	# Show white outline by default
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("show_outline", true)
	
func _on_area_entered(area: Area2D):
	if area is IngredientScene and area.is_dragging:
		RecipeManager.play_hover_sfx()
		update_outline(true)

func _on_area_exited(area: Area2D):
	if area is IngredientScene:
		# Check if any other dragging ingredients are still over the bowl
		var still_hovering = false
		for other_area in get_overlapping_areas():
			if other_area is IngredientScene and other_area.is_dragging:
				still_hovering = true
				break
		update_outline(still_hovering)

func update_outline(show: bool):
	if not shader_material:
		return
	
	if show:
		# Green outline when ingredient is dragging over
		shader_material.set_shader_parameter("outline_color", Color(0.0, 1.0, 0.0, 1.0))
		shader_material.set_shader_parameter("show_outline", true)
	else:
		# White outline by default
		shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
		shader_material.set_shader_parameter("show_outline", true)

func add_ingredient(ingredient: IngredientScene):
	if ingredient in ingredients_in_bowl:
		return
	
	ingredients_in_bowl.append(ingredient)
	
	# Track that this ingredient is in the bowl
	ingredient.in_mixing_bowl = self
	
	# Stop dragging
	ingredient.is_dragging = false
	
	# Only disable input if there are 2+ ingredients (so single ingredient can be dragged out)
	if ingredients_in_bowl.size() >= 2:
		for ing in ingredients_in_bowl:
			ing.input_pickable = false
	else:
		# Keep single ingredient draggable
		ingredient.input_pickable = true
	
	# Turn off the ingredient's outline
	shader_material.set_shader_parameter("show_outline", false)
	
	# Make ingredient smaller and position on top of bowl
	ingredient.scale = Vector2(0.6, 0.6)
	ingredient.global_position.x = global_position.x
	ingredient.global_position.y = global_position.y + MIXING_BOWL_OFFSET
	ingredient.z_index = 11
	
	# Stop timer when in bowl
	if ingredient.timer:
		ingredient.timer.stop()
	
	# If we have 2 or more ingredients, combine them
	if ingredients_in_bowl.size() >= 2:
		combine_ingredients()

func combine_ingredients():
	if ingredients_in_bowl.size() < 2:
		return
	
	var item_a = ingredients_in_bowl[0]
	var item_b = ingredients_in_bowl[1]
	
	# Store the bowl position for spawning
	var bowl_position = Vector2(global_position.x, global_position.y - 80)
	
	# Clear references for both ingredients
	item_a.in_mixing_bowl = null
	item_b.in_mixing_bowl = null
	
	# Remove from our tracking array
	ingredients_in_bowl.clear()
	
	# Use RecipeManager to combine with pop animation
	RecipeManager.combine_with_pop(item_a, item_b, bowl_position)
	
	sprite.play("on")
	await get_tree().create_timer(1.5).timeout
	sprite.play("default")

func remove_ingredient(ingredient: IngredientScene):
	# Remove from bowl tracking
	if ingredient in ingredients_in_bowl:
		ingredients_in_bowl.erase(ingredient)
	
	# Clear bowl reference
	ingredient.in_mixing_bowl = null
	
	# Restore ingredient properties
	ingredient.input_pickable = true
	ingredient.scale = Vector2(1.0, 1.0)
	
	# Restart timer when removed
	ingredient.start_timers()
	
	# If there's still one ingredient left, make it draggable
	if ingredients_in_bowl.size() == 1:
		ingredients_in_bowl[0].input_pickable = true
