extends Area2D
class_name IngredientSpawner

@export var ingredient_data: IngredientResource

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

const INGREDIENT_SCENE = preload("res://Scenes/Ingredient.tscn")
var shader_material: ShaderMaterial

func _ready():
	if ingredient_data:
		sprite.texture = ingredient_data.get_ingredient_icon()
	input_pickable = true
	
	# Setup outline shader
	var shader = preload("res://Assets/Art/outline.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	sprite.material = shader_material
	shader_material.set_shader_parameter("outline_width", 20.0)
	
	# Show white outline by default
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("show_outline", true)

	# Connect mouse signals for hover effect
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	RecipeManager.play_hover_sfx()
	shader_material.set_shader_parameter("outline_color", Color(0.5, 0.5, 0.5, 1.0))

func _on_mouse_exited():
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_ingredient()

func spawn_ingredient() -> IngredientScene:
	# Create new instance of the ingredient scene
	var new_ingredient: IngredientScene = INGREDIENT_SCENE.instantiate()
	new_ingredient.ingredient_data = ingredient_data.duplicate()
	
	# Add to the same parent (or scene tree)
	get_tree().current_scene.add_child(new_ingredient)
	
	# Position at mouse and start dragging immediately
	new_ingredient.global_position = get_global_mouse_position()
	new_ingredient.is_dragging = true
	new_ingredient.drag_offset = Vector2.ZERO
	new_ingredient.z_index = 110  # Set dragging z_index
	
	return new_ingredient
