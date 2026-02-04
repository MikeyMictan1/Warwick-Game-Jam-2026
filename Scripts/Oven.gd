extends Area2D

var shader_material: ShaderMaterial

@onready var sprite: Sprite2D = $Sprite2D

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

func _on_area_entered(area: Area2D):
	if area is IngredientScene and area.is_dragging:
		update_outline(true)

func _on_area_exited(area: Area2D):
	if area is IngredientScene:
		# Check if any other dragging ingredients are still over the oven
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
		# No outline
		shader_material.set_shader_parameter("show_outline", false)

func add_ingredient(ingredient: IngredientScene):
	print("Adding to oven: ", ingredient.ingredient_data.name)
	
	# Disable dragging and input for ingredient
	ingredient.is_dragging = false
	ingredient.input_pickable = false
	ingredient.update_outline()
	
	# Position ingredient in the oven
	ingredient.global_position = global_position
	ingredient.scale = Vector2(0.6, 0.6)
	ingredient.z_index = 1
	
	# Turn off green glow
	update_outline(false)
	
	# Use RecipeManager to cook
	RecipeManager.combine_oven(ingredient, global_position)
