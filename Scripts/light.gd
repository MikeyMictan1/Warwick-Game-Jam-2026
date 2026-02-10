extends Area2D

enum LightState { GREEN, RED, ORANGE }

var current_state: LightState = LightState.GREEN
var state_timer: Timer
var check_timer: Timer
var red_was_pressed: bool = false


@onready var sprite: Sprite2D = $Sprite2D

@onready var point_light: PointLight2D = $PointLight2D
var shader_material: ShaderMaterial

func _ready():
	# Add to light group for easy access
	add_to_group("light")
	
	# Create timer for checking every 10 seconds
	check_timer = Timer.new()
	check_timer.wait_time = 10.0
	check_timer.one_shot = false
	check_timer.timeout.connect(_on_check_timer_timeout)
	add_child(check_timer)
	state_timer = Timer.new()
	state_timer.wait_time = 5.0
	state_timer.one_shot = true
	state_timer.timeout.connect(_on_state_timer_timeout)
	add_child(state_timer)
	
	# Connect input event
	input_event.connect(_on_input_event)
	
	# SHADRESSS
	# Setup outline shader
	var shader = preload("res://Assets/Art/outline.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	sprite.material = shader_material
	shader_material.set_shader_parameter("outline_width", 20.0)
	
	# Show white outline by default
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("show_outline", true)
	
	# Set initial green state
	update_sprite()
	
func _on_mouse_entered():
	RecipeManager.play_hover_sfx()
	shader_material.set_shader_parameter("outline_color", Color(0.5, 0.5, 0.5, 1.0))

func _on_mouse_exited():
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))

func start_timer():
	# Called when dialogue is complete to start the light cycle
	check_timer.start()

func pause_light_system():
	# Pause all timers and reset to green state
	check_timer.paused = true
	state_timer.paused = true
	if current_state != LightState.GREEN:
		set_state(LightState.GREEN)
		red_was_pressed = false

func resume_light_system():
	# Resume the light cycle
	check_timer.paused = false
	state_timer.paused = false

func _on_check_timer_timeout():
	# Random chance to turn red or orange
	var rand = randf()
	if rand < 0.5:  # 50% chance to trigger
		if randf() < 0.5:  # 50/50 between red and orange
			set_state(LightState.RED)
		else:
			set_state(LightState.ORANGE)
		state_timer.start()

func _on_state_timer_timeout():
	# If red light was not pressed, explode
	if current_state == LightState.RED and not red_was_pressed:
		RecipeManager.explode_kitchen("You didn't press the red light in time!")
	
	# Return to green after 3 seconds
	set_state(LightState.GREEN)
	red_was_pressed = false

func set_state(new_state: LightState):
	current_state = new_state
	update_sprite()
	# Reset red pressed flag when changing state
	if new_state == LightState.RED:
		red_was_pressed = false

func update_sprite():
	match current_state:
		LightState.GREEN:
			sprite.texture = load("res://Assets/Art/lights/green_light.png")
			point_light.color = Color(0.001, 0.065, 0.0, 1)
			point_light.energy = 10.36
		LightState.RED:
			sprite.texture = load("res://Assets/Art/lights/red_light.png")
			point_light.color = Color(0.8, 0.004, 0.0, 1)
			point_light.energy = 5
		LightState.ORANGE:
			sprite.texture = load("res://Assets/Art/lights/orange_light.png")
			point_light.color = Color(0.493, 0.117, 0.0, 1)
			point_light.energy = 5

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		MusicManager.play_click_sfx()
		match current_state:
			LightState.GREEN:
				on_pressed_green()
			LightState.RED:
				on_pressed_red()
			LightState.ORANGE:
				on_pressed_orange()

# pressed while green
func on_pressed_green():
	pass

# Called when pressed while red
func on_pressed_red():
	# Pressing red prevents explosion and returns to green
	red_was_pressed = true
	state_timer.stop()
	set_state(LightState.GREEN)

# Called when pressed while orange
func on_pressed_orange():
	# Pressing orange causes explosion
	state_timer.stop()
	RecipeManager.explode_kitchen("Don't press the light when it is atomic tangerine.")
	set_state(LightState.GREEN)
	pass
