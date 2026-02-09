extends CanvasLayer

# Discovered ingredients stored by name to avoid duplicates
var discovered: Dictionary = {}

@onready var panel: Panel = $Panel
@onready var grid: GridContainer = $Panel/ScrollContainer/GridContainer
@onready var close_button: Button = $Panel/CloseButton
@onready var book_button: TextureButton = $BookButton

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
	
	# Register default ingredients
	for path in default_ingredients:
		var res: IngredientResource = load(path)
		if res:
			discover_ingredient(res)

func _on_book_pressed():
	panel.visible = true
	get_tree().paused = true

func _on_close_pressed():
	panel.visible = false
	get_tree().paused = false

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
	entry.add_theme_constant_override("separation", 4)
	
	# Icon
	var icon = TextureRect.new()
	icon.texture = ingredient.get_ingredient_icon()
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(80, 80)
	entry.add_child(icon)
	
	# Name label
	var label = Label.new()
	label.text = ingredient.get_ingredient_name().replace("_", " ")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 14)
	entry.add_child(label)
	
	grid.add_child(entry)
