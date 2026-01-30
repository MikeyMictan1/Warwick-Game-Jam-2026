extends Area2D
class_name IngredientScene

# This is where the .tres file goes
@export var ingredient_data: IngredientResource:
	set(new_data):
		ingredient_data = new_data
		if is_inside_tree():
			_apply_data()

func _ready():
	_apply_data()

func _apply_data():
	if ingredient_data:
		$Sprite2D.texture = ingredient_data.icon
