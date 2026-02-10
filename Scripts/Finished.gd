extends Area2D

@onready var sprite : Sprite2D = $Sprite2D2
var shader_material: ShaderMaterial
var held_ingredient: IngredientScene = null
@export var tomato_pasta : IngredientScene

func _ready():
	add_to_group("finished_plate")
	
		# Setup outline shader
	var shader = preload("res://Assets/Art/outline.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	sprite.material = shader_material
	
	# Show white outline by default
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("show_outline", true)

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
		ingredient.z_index = 11
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
