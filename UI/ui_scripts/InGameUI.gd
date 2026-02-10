extends CanvasLayer

@onready var pause_menu = $Pages/PauseMenu  # Adjust path as needed
@onready var controls_menu = $Pages/Controls # Adjust path as needed
var recipe_book = null

func _ready():
	# Connect to game state changes
	GameManager.game_state_changed.connect(_on_game_state_changed)
	GameManager.pause_state_changed.connect(_on_pause_state_changed)
	
	# Initially hide menus
	if pause_menu:
		pause_menu.visible = false
	if controls_menu:
		controls_menu.visible = false
	
	# Get reference to RecipeBook
	call_deferred("_find_recipe_book")

func _find_recipe_book():
	# Find the RecipeBook node in the scene tree
	var root = get_tree().current_scene
	if root:
		recipe_book = root.get_node_or_null("RecipeBook")
		if not recipe_book:
			# Try searching in children
			for child in root.get_children():
				if child.name == "RecipeBook":
					recipe_book = child
					break

func _input(event):
	# Only process input when in game
	if not GameManager.is_in_game:
		return
	
	if event.is_action_pressed("toggle_pause"):  # ESC key
		_toggle_pause_menu()
	elif event.is_action_pressed("toggle_controls"):  # TAB key
		_toggle_recipe_book()

func _toggle_pause_menu():
	if recipe_book and recipe_book.panel.visible:
		# Close recipe book first
		recipe_book._on_close_button_pressed()
	
	GameManager.toggle_pause()
	if pause_menu:
		pause_menu.visible = GameManager.is_paused

func _toggle_recipe_book():
	if recipe_book and not GameManager.is_paused:
		recipe_book._on_book_button_pressed()
			
func _on_game_state_changed(in_game: bool):
	visible = in_game
	if in_game:
		# Find recipe book when entering game
		call_deferred("_find_recipe_book")
	else:
		# Hide all menus when leaving game
		if pause_menu:
			pause_menu.visible = false
		if controls_menu:
			controls_menu.visible = false
		if recipe_book:
			recipe_book._on_close_button_pressed()

func _on_pause_state_changed(paused: bool):
	if pause_menu:
		pause_menu.visible = paused and GameManager.is_in_game

func _on_resume_button_pressed() -> void:
	_toggle_pause_menu()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/ui_scenes/MainMenu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
