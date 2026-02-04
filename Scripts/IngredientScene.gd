extends Area2D
class_name IngredientScene

@export var ingredient_data: IngredientResource

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var is_hovering: bool = false
var shader_material: ShaderMaterial

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
		if area.name in ["MixingBowl", "Oven", "WashingMachine"]:
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
				# Set z-index to 100 while dragging
				z_index = 100
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
			# Set z-index back to 1 after release
			z_index = 1
			update_outline()
			try_combine()

# Move the position to the mouse position every frame (+ initial offset)
func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
		update_outline()  # Update outline to check if over appliance

func try_combine():
	# Check if we're overlapping with a mixing bowl
	for other_area in get_overlapping_areas():
		if other_area.name == "MixingBowl":
			print("Adding to mixing bowl: ", ingredient_data.name)
			other_area.add_ingredient(self)
			return

func pop_out():
	# Play the pop_out animation from the AnimationPlayer
	if animation_player:
		animation_player.play("pop_out")

		
