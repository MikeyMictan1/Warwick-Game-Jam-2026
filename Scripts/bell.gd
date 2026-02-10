extends Area2D
var shader_material: ShaderMaterial

@onready var sprite : Sprite2D = $Sprite2D
@export var finished_plate: Area2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		MusicManager.play_bell_sfx()
		finished_plate.submitted()

func _ready():
	var shader = preload("res://Assets/Art/outline.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	sprite.material = shader_material
	shader_material.set_shader_parameter("outline_width", 7.0)
	
	# Show white outline by default
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("show_outline", true)

func _on_mouse_entered():
	RecipeManager.play_hover_sfx()
	shader_material.set_shader_parameter("outline_color", Color(0.5, 0.5, 0.5, 1.0))

func _on_mouse_exited():
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
