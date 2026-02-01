extends Resource
class_name IngredientResource

@export var name : String = ""
@export var icon: Texture2D
@export var components: Array[IngredientResource] = [] # What ingredients made this (leave empty, is populated at runtime)

# Getters
func get_ingredient_name():
	return name

func get_ingredient_icon():
	return icon

func contains_ingredient(target: IngredientResource) -> bool:
	# Direct match
	if self == target:
		return true

	# Check components recursively
	for component in components:
		if component == target:
			return true
			
	return false
