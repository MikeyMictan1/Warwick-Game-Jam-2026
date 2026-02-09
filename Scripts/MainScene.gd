extends Node2D

var start_intro: bool
@onready var panel: Panel = $Panel
@onready var speech_text: RichTextLabel = $Panel/SpeechText
@onready var audio_stream_speech: AudioStreamPlayer2D = $Panel/AudioStreamSpeech

@onready var arrow_1 : TextureRect = $arrows/arrow_1
@onready var arrow_2 : TextureRect = $arrows/arrow_2
@onready var arrow_3 : TextureRect = $arrows/arrow_3
@onready var arrow_4 : TextureRect = $arrows/arrow_4
@onready var arrow_5 : TextureRect = $arrows/arrow_5

func _ready():
	# Set game state when entering the game scene
	GameManager.set_in_game(true)
	start_intro = true
	
	# Create auto-advance timer
	auto_advance_timer = Timer.new()
	auto_advance_timer.one_shot = true
	auto_advance_timer.timeout.connect(_on_auto_advance_timeout)
	add_child(auto_advance_timer)


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
var auto_advance_timer: Timer

var dialogue = [
	"Hey'a Young'in!",
	"Welcome to the restaurant!",
	"Your goal is to cook some delectable pasta with tomato sauce! easy, right!",
	"There's a few rules you should be a-knowin about, so pay VERY VERY VERY VERY close",
	"attention to what i'm about to tell you.",
	"Take any two ingredients, and mix 'em together in the mixin bowl!",
	"Be careful what you mix, as you could be creatin horrors...",
	"If you think you've made tomato pasta, put it on the plate and ring the bell!",
	"You've also got a washing machine to wash your ingredients!",
	"But dont wash sponges as they will flood the kitchen.",
	"Your oven here is Falsie! Falsie will cook up any ingredient u throw at her!",
	"However, falsie HATES tomato-based foods apart from a certain pasta sauce, so be careful",
	"when feedin her.",
	"It's also important to note that this light over here will sometimes turn red.",
	"If it does, you've got 3 seconds to press it! I recommend that you do.",
	"BUT! The light can also turn a shade of Atomic tangerine - in which case, do NOT press it,",
	"just let it be.",
	"For making Pasta with Tomato Sauce, you will need to combine boiling pasta with hot pasta sauce.",
	"The pasta sauce will need caramelised onions, garlic oil, and lots of tomato.",
	"The resturant has accidentally supplied bomb blueprints - these have a chance to turn into a real",
	"bomb. In this event, please de-fuse the bomb with the provided instructions.",
	"The supplied dried pasta is very good for makin pizza, but don't try to make pineapple pizza",
	"otherwise the police will close the restaurant.",
	"You have a recipe book to see what you've made so far if you get confused!",
	"-Sorry, I've got no time to explain any more, good luck!"
]

# progresses on dialogue
func talk():
	is_talking = true
	start_intro = false
	if current_index >= dialogue.size():
		is_talking = false
		panel.visible = false
		# Hide all arrows when dialogue ends
		hide_all_arrows()
		return
	
	# Update arrow visibility and position based on current dialogue
	update_arrow()
	
	if typing == true: # happens if player presses space again to skip/end dialogue
		typing = false
		speech_text.text = dialogue[current_index]
		current_index+=1
		# Cancel auto-advance and restart it
		if auto_advance_timer.time_left > 0:
			auto_advance_timer.stop()
		var wait_time = 0.5 if current_index > 13 else 1.0
		auto_advance_timer.start(wait_time)
	# otherwise, start typing the current text
	else:
		typing = true
		start_typing(dialogue[current_index])

# used to let the interviewer/player speak
func start_typing(text: String) -> void:
	await get_tree().process_frame  # let UI update first
	# Determine typing speed based on current index
	var typing_delay = 0.01 if current_index > 13 else 0.02
	
	for i in range(text.length()):
		speech_text.text = text.substr(0, i + 1)
		
		audio_stream_speech.pitch_scale = 0.8 + randf_range(-0.1,0.1)
		if text.substr(0, i + 1) in ['a','e','i','o','u']:
			audio_stream_speech.pitch_scale += 0.2
		audio_stream_speech.play()
		
		if typing == true:
			await get_tree().create_timer(typing_delay).timeout
			# wait a bit before next letter is added
		audio_stream_speech.stop()
	if typing == true:
		typing = false
		current_index+=1
		# Start auto-advance timer after typing finishes
		var wait_time = 0.5 if current_index > 13 else 1.0
		auto_advance_timer.start(wait_time)

func _on_auto_advance_timeout():
	if is_talking and not typing:
		talk()

func hide_all_arrows():
	arrow_1.visible = false
	arrow_2.visible = false
	arrow_3.visible = false
	arrow_4.visible = false
	arrow_5.visible = false

func update_arrow():
	# Hide all arrows first
	hide_all_arrows()
	
	# Show appropriate arrow based on dialogue index
	if current_index == 5:  # "mix 'em together in the mixin bowl!"
		arrow_1.visible = true
	elif current_index == 7:  # "put it on the plate and ring the bell!"
		arrow_2.visible = true
	elif current_index == 8:  # "washing machine to wash your ingredients!"
		arrow_3.visible = true
	elif current_index == 10:  # "Your oven here is Falsie!"
		arrow_4.visible = true
	elif current_index == 13:  # "this light over here will sometimes turn red."
		arrow_5.visible = true
