extends Area2D
class_name IngredientScene

@export var ingredient_data: IngredientResource

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready():
	sprite.texture = ingredient_data.get_ingredient_icon()
	input_pickable = true

func _input_event(_viewport, event, _shape_idx):
	# This is called when input happens INSIDE the collision shape
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_dragging = true
			drag_offset = global_position - get_global_mouse_position()

func _input(event):
	# Dont care if not dragging
	if not is_dragging:
		return
	
	# For the first frame the mouse is released while dragging, set dragging to false, and try combine logic
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_dragging = false
			try_combine()

# Move the position to the mouse position every frame (+ initial offset)
func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset

func try_combine():
	for other_area in get_overlapping_areas():
		if other_area is IngredientScene:
			print("Combining: ", ingredient_data.name, " + ", other_area.ingredient_data.name)
			RecipeManager.combine(self, other_area)
			return
