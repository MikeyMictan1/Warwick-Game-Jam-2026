extends Area2D
class_name IngredientScene

@export var ingredient_data: IngredientResource

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer : Timer = $Timer
@onready var blink_timer : Timer = $BlinkTimer
@onready var fade_player: AnimationPlayer = $FadePlayer
@onready var death_player: AnimationPlayer = $DeathPlayer

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var is_hovering: bool = false
var shader_material: ShaderMaterial
var current_slot: Area2D = null  # Track which slot this ingredient is in
var is_blinking: bool = false

func start_timers():
	if timer and blink_timer:
		timer.one_shot = true
		blink_timer.one_shot = true
		timer.start()
		blink_timer.start()
		
func stop_timers():
	# Logic for blinking
	is_blinking = false
	print("stopping fade player")
	if fade_player:
		fade_player.stop()
	timer.stop()
	blink_timer.stop()
	
	sprite.modulate.a = 1.0

func _ready():

	sprite.texture = ingredient_data.get_ingredient_icon()
	input_pickable = true
	
	# Setup outline shader
	var shader = preload("res://Assets/Art/outline.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	sprite.material = shader_material
	
	# Connect mouse signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Setup timer for ingredient lifetime (15 seconds)
	start_timers()

func _on_mouse_entered():
	is_hovering = true
	update_outline()

func _on_mouse_exited():
	is_hovering = false
	update_outline()

func update_outline():
	if not shader_material:
		return
	
	# Priority: Green (over appliance) > Grey (dragging) > White (hovering) AAAHAH IT WORKS KINDA IDK IMMAKM GION G TO CRY
	if is_dragging and is_over_appliance():
		# Green outline when dragging over an appliance
		shader_material.set_shader_parameter("outline_color", Color(0.0, 1.0, 0.0, 1.0))
		shader_material.set_shader_parameter("show_outline", true)
	elif is_dragging:
		# Grey outline when dragging
		shader_material.set_shader_parameter("outline_color", Color(0.5, 0.5, 0.5, 1.0))
		shader_material.set_shader_parameter("show_outline", true)
	elif is_hovering:
		# White outline when hovering
		shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
		shader_material.set_shader_parameter("show_outline", true)
	else:
		# No outline
		shader_material.set_shader_parameter("show_outline", false)

func is_over_appliance() -> bool:
	for area in get_overlapping_areas():
		if area.name in ["MixingBowl", "Oven", "WashingMachine", "FinishedPlate"]:
			return true
		if area.name.begins_with("slot_"):
			return true
	return false

func _input_event(_viewport, event, _shape_idx):
	# This is called when input happens INSIDE the collision shape
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Check if this is the topmost ingredient at this position
			var topmost = true
			for area in get_overlapping_areas():
				if area is IngredientScene and area.z_index > z_index:
					topmost = false
					break

			if topmost:
				is_dragging = true
				drag_offset = global_position - get_global_mouse_position()
				# Set z-index to 110 while dragging
				z_index = 110

				# If in finished plate, remove from it
				var finished_plate = get_tree().get_first_node_in_group("finished_plate")
				if finished_plate and finished_plate.held_ingredient == self:
					finished_plate.remove_ingredient()
				
				# If in a slot, remove from it
				if current_slot != null:
					var chopping_board = get_tree().get_first_node_in_group("chopping_board")
					if chopping_board:
						chopping_board.remove_ingredient_from_slot(self)
				
				update_outline()
				# Prevent this event from reaching ingredients below this one
				get_viewport().set_input_as_handled()

func _input(event):
	# Dont care if not dragging
	if not is_dragging:
		return
	
	# For the first frame the mouse is released while dragging, set dragging to false, and try combine logic
	if event is InputEventMouseButton:		
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_dragging = false
			# Set z-index back to 100 after release
			z_index = 100
			update_outline()
			try_combine()

# Move the position to the mouse position every frame (+ initial offset)
func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
		update_outline()  # Update outline to check if over appliance
	
func ingredient_blink():
	# Handle blinking for ingredients not on chopping board
	if current_slot == null and timer:
		var time_left = timer.time_left
		
		# Start blinking after 10 seconds (5 seconds left on timer)
		if time_left <= 5.0 and not is_blinking:
			is_blinking = true
			if fade_player and not fade_player.is_playing():
				fade_player.play("fade")
				
			
func _on_timer_timeout():
	print("timeout")
	# Delete ingredient when timer runs out
	fade_player.stop()
	death_player.play("death")

func _on_blink_timer_timeout() -> void:
	print("blink timeout")
	ingredient_blink()

func try_combine():
	# Check if we're overlapping with chopping board slots first
	var overlapping_slots = []
	for other_area in get_overlapping_areas():
		if other_area.name.begins_with("slot_"):
			overlapping_slots.append(other_area)
	# If overlapping multiple slots, find the one with most overlap
	if overlapping_slots.size() > 0:
		var best_slot = null
		var max_overlap = 0.0
		for slot in overlapping_slots:
			var distance = global_position.distance_to(slot.global_position)
			var overlap_score = 1.0 / (distance + 1.0)
			if overlap_score > max_overlap:
				max_overlap = overlap_score
				best_slot = slot
		if best_slot:
			var chopping_board = get_tree().get_first_node_in_group("chopping_board")
			if chopping_board:
				stop_timers()
				if chopping_board.try_add_ingredient_to_slot(self, best_slot):
					return

	# Check if we're overlapping with appliances (including Finished)
	for other_area in get_overlapping_areas():
		if other_area.name == "MixingBowl":
			stop_timers()
			print("Adding to mixing bowl: ", ingredient_data.name)
			other_area.add_ingredient(self)
			return
		elif other_area.name == "Oven":
			stop_timers()
			print("Adding to oven: ", ingredient_data.name)
			other_area.add_ingredient(self)
			return
		elif other_area.name == "WashingMachine":
			stop_timers()
			print("Adding to washing machine: ", ingredient_data.name)
			other_area.add_ingredient(self)
			return
		elif other_area.name == "FinishedPlate":
			stop_timers()
			print("Adding to finished plate: ", ingredient_data.name)
			if other_area.add_ingredient(self):
				return
		elif other_area.name == "Bin":
			kill_ingredient()

func pop_out():
	# Play the pop_out animation from the AnimationPlayer
	if animation_player:
		animation_player.play("pop_out")

"""
Ingredient name resources getter
"""
func get_ingredient_name():
	if ingredient_data:
		return ingredient_data.name

func kill_ingredient():
	death_player.play("death")
