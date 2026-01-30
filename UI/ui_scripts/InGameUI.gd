extends CanvasLayer

@onready var pause_menu = $Pages/PauseMenu  # Adjust path as needed
@onready var controls_menu = $Pages/Controls # Adjust path as needed

func _ready():
	# Connect to game state changes
	GameManager.game_state_changed.connect(_on_game_state_changed)
	GameManager.pause_state_changed.connect(_on_pause_state_changed)
	
	# Initially hide menus
	if pause_menu:
		pause_menu.visible = false
	if controls_menu:
		controls_menu.visible = false

func _input(event):
	# Only process input when in game
	if not GameManager.is_in_game:
		return
	
	if event.is_action_pressed("toggle_pause"):  # ESC key
		_toggle_pause_menu()
	elif event.is_action_pressed("toggle_controls"):  # TAB key
		_toggle_controls_menu()

func _toggle_pause_menu():
	if controls_menu and controls_menu.visible:
		# Close controls menu first
		controls_menu.visible = false
	
	GameManager.toggle_pause()
	if pause_menu:
		pause_menu.visible = GameManager.is_paused

func _toggle_controls_menu():
	if not GameManager.is_paused:		
		if controls_menu.visible:
			controls_menu.visible = false
		else:
			controls_menu.visible = true
			
func _on_game_state_changed(in_game: bool):
	visible = in_game
	if not in_game:
		# Hide all menus when leaving game
		if pause_menu:
			pause_menu.visible = false
		if controls_menu:
			controls_menu.visible = false

func _on_pause_state_changed(paused: bool):
	if pause_menu:
		pause_menu.visible = paused and GameManager.is_in_game

func _on_resume_button_pressed() -> void:
	_toggle_pause_menu()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/ui_scenes/MainMenu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
