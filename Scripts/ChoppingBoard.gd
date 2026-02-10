extends Node2D

# Dictionary to track which ingredient is in which slot
var slot_contents: Dictionary = {}

func _ready() -> void:
	# Initialize all slots as empty
	for i in range(1, 11):
		var slot_name = "slot_" + str(i)
		slot_contents[slot_name] = null
		# Connect hover SFX for each slot
		var slot = get_node(slot_name)
		slot.area_entered.connect(_on_slot_area_entered)

func _on_slot_area_entered(area: Area2D):
	if area is IngredientScene and area.is_dragging:
		RecipeManager.play_hover_sfx()

func try_add_ingredient_to_slot(ingredient: IngredientScene, slot: Area2D) -> bool:
	# Check if slot is empty
	if slot_contents[slot.name] == null:
		# Add ingredient to slot
		slot_contents[slot.name] = ingredient
		ingredient.current_slot = slot

		# MAKING SURE THE TIMER IS STOPPED, SO IT STAYS ALIVE
		# Stop timer when placed on board
		if ingredient.timer:
			ingredient.timer.stop()

		# Snap ingredient to slot position
		ingredient.global_position = slot.global_position
		ingredient.z_index = 11
		return true
	else:
		return false

func remove_ingredient_from_slot(ingredient: IngredientScene):
	if ingredient.current_slot != null:
		var slot_name = ingredient.current_slot.name
		
		if slot_contents.has(slot_name):
			slot_contents[slot_name] = null

		ingredient.current_slot = null

		# Restart timers when removed to the board
		ingredient.start_timers()
