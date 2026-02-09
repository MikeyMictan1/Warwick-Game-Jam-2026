extends Area2D

var shader_material: ShaderMaterial
@onready var audio_stream_speech: AudioStreamPlayer2D = $AudioStreamSpeech
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var speech_text: RichTextLabel = $Panel/SpeechText
@onready var panel: Panel = $Panel

func _ready():
	input_pickable = false
	
	# Setup outline shader
	var shader = preload("res://Assets/Art/outline.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	sprite.material = shader_material
	
	# Connect area signals to detect when ingredients hover over
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	# Show white outline by default
	shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("show_outline", true)
	
	panel.visible = false

func _on_area_entered(area: Area2D):
	if area is IngredientScene and area.is_dragging:
		RecipeManager.play_hover_sfx()
		update_outline(true)

func _on_area_exited(area: Area2D):
	if area is IngredientScene:
		# Check if any other dragging ingredients are still over the oven
		var still_hovering = false
		for other_area in get_overlapping_areas():
			if other_area is IngredientScene and other_area.is_dragging:
				still_hovering = true
				break
		update_outline(still_hovering)

func update_outline(show: bool):
	if not shader_material:
		return
	if show:
		# Green outline when ingredient is dragging over
		shader_material.set_shader_parameter("outline_color", Color(0.0, 1.0, 0.0, 1.0))
		shader_material.set_shader_parameter("show_outline", true)
	else:
		# White outline by default
		shader_material.set_shader_parameter("outline_color", Color(1.0, 1.0, 1.0, 1.0))
		shader_material.set_shader_parameter("show_outline", true)


func add_ingredient(ingredient: IngredientScene):
	print("Adding to oven: ", ingredient.ingredient_data.name)
	cur_ingredient_obj = ingredient
	
	# Disable dragging and input for ingredient
	ingredient.is_dragging = false
	ingredient.input_pickable = false
	ingredient.update_outline()
	
	# Position ingredient in the oven
	ingredient.global_position = global_position
	ingredient.scale = Vector2(0.6, 0.6)
	ingredient.z_index = 11
	
	# Turn off green glow
	update_outline(false)
	
	cur_ingredient = ingredient.ingredient_data.name
	current_index = 0
	is_talking = true
	panel.visible = true
	talk()
	sprite.play("talking")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and is_talking:
		talk()

func actually_cook():
	# Use RecipeManager to cook
	RecipeManager.combine_oven(cur_ingredient_obj, global_position)

var typing = false
var cur_ingredient
var cur_ingredient_obj
var current_index = 0
var is_talking = false

# progresses on dialogue
func talk():
	var cur_dialogue : Array = ["nom nom nom"]
	if fire_dialogue.has(cur_ingredient):
		cur_dialogue = fire_dialogue[cur_ingredient]
	
	if current_index >= cur_dialogue.size():
		is_talking = false
		panel.visible = false
		actually_cook()
		sprite.play("idle")
		return
	
	if typing == true: # happens if player presses space again to skip/end dialogue
		typing = false
		speech_text.text = cur_dialogue[current_index]
		current_index+=1
	# otherwise, start typing the current text
	else:
		typing = true
		start_typing(cur_dialogue[current_index])

# used to let the interviewer/player speak
func start_typing(text: String) -> void:
	await get_tree().process_frame  # let UI update first
	for i in range(text.length()):
		speech_text.text = text.substr(0, i + 1)
		
		audio_stream_speech.pitch_scale = 0.8 + randf_range(-0.1,0.1)
		if text.substr(0, i + 1) in ['a','e','i','o','u']:
			audio_stream_speech.pitch_scale += 0.2
		audio_stream_speech.play()
		
		if typing == true:
			await get_tree().create_timer(0.02).timeout
			# wait a bit before next letter is added
		audio_stream_speech.stop()
	if typing == true:
		typing = false
		current_index+=1


var fire_dialogue = {"Garlic":["omg you're cooking lettuce??", "that's crazy bro"]}
