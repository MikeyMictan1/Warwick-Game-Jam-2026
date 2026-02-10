extends Node2D

var shader_material: ShaderMaterial

@onready var bomb_button: Sprite2D = $BombButton
@onready var bomb_bg: Sprite2D = $BombBg
var game_timer
@onready var timer_text: RichTextLabel = $TimerText


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_timer = 30
	# Setup outline shader
	var shader = preload("res://Assets/Art/outline.gdshader")
	
	for c in bomb_bg.get_children():
		if "Button" in c.name:
			var mat = ShaderMaterial.new()
			mat.shader = shader
			c.material = mat
			c.set_meta("outline_mat", mat)
			
			var a: Area2D = c.get_child(0)
			a.mouse_entered.connect(_on_area_entered.bind(a))
			a.mouse_exited.connect(_on_area_exited.bind(a))
			
			if "Correct" in c.name:
				a.input_event.connect(yay.bind(a))
			else:
				a.input_event.connect(boom.bind(a))


func _on_area_entered(area: Area2D):
	var button := area.get_parent()
	shader_material = button.get_meta("outline_mat")
	update_outline(true)

func _on_area_exited(area: Area2D):
	var button := area.get_parent()
	shader_material = button.get_meta("outline_mat")
	update_outline(false)

func boom(viewport: Viewport,event: InputEvent,shape_idx: int,area: Area2D):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		RecipeManager.explode_kitchen()

func yay(viewport: Viewport,event: InputEvent,shape_idx: int,area: Area2D):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		self.queue_free()

func update_outline(show: bool):
	if not shader_material:
		return
	
	if show:
		# Green outline when ingredient is dragging over
		shader_material.set_shader_parameter("outline_color", Color(0.0, 1.0, 0.0, 1.0))
		shader_material.set_shader_parameter("show_outline", true)
	else:
		# No outline
		shader_material.set_shader_parameter("show_outline", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_timer -= delta
	var minutes = int(game_timer / 60)
	var seconds = int(game_timer) % 60
	var milliseconds = int((game_timer - int(game_timer)) * 100)
	
	timer_text.text = "%02d:%02d" % [seconds, milliseconds]
