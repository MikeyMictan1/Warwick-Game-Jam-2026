extends CanvasLayer

# Discovered ingredients stored by name to avoid duplicates
var discovered: Dictionary = {}
var shader_material: ShaderMaterial

@onready var panel: Panel = $Panel
@onready var grid: GridContainer = $Panel/ScrollContainer/GridContainer
@onready var close_button: Button = $Panel/CloseButton
@onready var book_button: TextureButton = $BookButton
@onready var book_texture : TextureRect = $BookTexture

# Default ingredients that are known from the start (the 6 spawners)
var default_ingredients: Array[String] = [
	"res://Resources/Lettuce.tres",
	"res://Resources/Garlic.tres",
	"res://Resources/Bomb_Picture.tres",
	"res://Resources/Tomato_Sauce.tres",
	"res://Resources/Pufferfish.tres",
	"res://Resources/Dried_Pasta.tres",
]

func _ready():
	panel.visible = false
	close_button.pressed.connect(_on_close_pressed)
	book_button.pressed.connect(_on_book_pressed)
	book_button.mouse_entered.connect(_on_book_mouse_entered)
	book_button.mouse_exited.connect(_on_book_mouse_exited)
	
	# Setup outline shader for book button
	var shader = preload("res://Assets/Art/outline.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	book_button.material = shader_material
	book_texture.material = shader_material
	
	# Show white outline by default
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("show_outline", true)
	
	# Register default ingredients
	for path in default_ingredients:
		var res: IngredientResource = load(path)
		if res:
			discover_ingredient(res)

func _on_book_pressed():
	# Toggle the panel
	if panel.visible:
		_on_close_pressed()
	else:
		panel.visible = true
		get_tree().paused = true

func _on_close_pressed():
	panel.visible = false
	if get_tree():
		get_tree().paused = false

func _unhandled_input(event):
	if not panel.visible:
		return
	
	# Close on Escape — mark handled so it doesn't trigger the settings menu
	if event.is_action_pressed("ui_cancel"):
		_on_close_pressed()
		get_viewport().set_input_as_handled()
		return
	
	# Close when clicking outside the panel
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var panel_rect = Rect2(panel.global_position, panel.size)
		if not panel_rect.has_point(event.global_position):
			_on_close_pressed()
			get_viewport().set_input_as_handled()

func discover_ingredient(ingredient: IngredientResource) -> void:
	var ing_name = ingredient.get_ingredient_name()
	if ing_name == "" or discovered.has(ing_name):
		return
	
	discovered[ing_name] = ingredient
	_add_entry(ingredient)

func _add_entry(ingredient: IngredientResource) -> void:
	# Container for each entry
	var entry = VBoxContainer.new()
	entry.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	entry.add_theme_constant_override("separation", 8)
	
	# Icon
	var icon = TextureRect.new()
	icon.texture = ingredient.get_ingredient_icon()
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(120, 120)
	entry.add_child(icon)
	
	# Name label
	var label = Label.new()
	label.text = ingredient.get_ingredient_name().replace("_", " ")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 20)
	entry.add_child(label)
	
	grid.add_child(entry)

func _on_book_mouse_entered():
	# Play tick SFX and change outline to grey
	RecipeManager.play_hover_sfx()
	shader_material.set_shader_parameter("outline_color", Color(0.5, 0.5, 0.5, 1.0))

func _on_book_mouse_exited():
	# Change outline back to white
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
