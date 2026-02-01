extends Area2D
class_name IngredientSpawner

@export var ingredient_data: IngredientResource

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

const INGREDIENT_SCENE = preload("res://Scenes/Ingredient.tscn")

func _ready():
	if ingredient_data:
		sprite.texture = ingredient_data.get_ingredient_icon()
	input_pickable = true

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
	
	return new_ingredient
