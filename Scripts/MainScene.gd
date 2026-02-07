extends Node2D

var start_intro: bool
@onready var panel: Panel = $Panel
@onready var speech_text: RichTextLabel = $Panel/SpeechText
@onready var audio_stream_speech: AudioStreamPlayer2D = $Panel/AudioStreamSpeech

func _ready():
	# Set game state when entering the game scene
	GameManager.set_in_game(true)
	start_intro = true

func _exit_tree():
	# Reset game state when leaving the game scene
	GameManager.set_in_game(false)
	GameManager.set_paused(false)

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("click") and is_talking) or start_intro:
		talk()

var typing = false
var current_index = 0
var is_talking = false

var dialogue = ["it will start", "and stop"]

# progresses on dialogue
func talk():
	is_talking = true
	start_intro = false
	if current_index >= dialogue.size():
		is_talking = false
		panel.visible = false
		return
	
	if typing == true: # happens if player presses space again to skip/end dialogue
		typing = false
		speech_text.text = dialogue[current_index]
		current_index+=1
	# otherwise, start typing the current text
	else:
		typing = true
		start_typing(dialogue[current_index])

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
