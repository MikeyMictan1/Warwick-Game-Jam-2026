extends Node2D

# Dictionary to track which ingredient is in which slot
var slot_contents: Dictionary = {}

func _ready() -> void:
	# Initialize all slots as empty
	for i in range(1, 11):
		var slot_name = "slot_" + str(i)
		slot_contents[slot_name] = null

func try_add_ingredient_to_slot(ingredient: IngredientScene, slot: Area2D) -> bool:
	# Check if slot is empty
	if slot_contents[slot.name] == null:
		# Add ingredient to slot
		slot_contents[slot.name] = ingredient
		ingredient.current_slot = slot
		# Snap ingredient to slot position
		ingredient.global_position = slot.global_position
		ingredient.z_index = 1
		print("Placed ingredient in ", slot.name)
		return true
	else:
		print("Slot ", slot.name, " is already occupied")
		return false

func remove_ingredient_from_slot(ingredient: IngredientScene):
	if ingredient.current_slot != null:
		var slot_name = ingredient.current_slot.name
		if slot_contents.has(slot_name):
			slot_contents[slot_name] = null
			print("Removed ingredient from ", slot_name)
		ingredient.current_slot = null
