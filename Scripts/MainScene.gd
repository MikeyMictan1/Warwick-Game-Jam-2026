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

@onready var light: Area2D = $Appliances/light

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
	"There's a few rules you should be a-knowin about, so pay VERY VERY VERY VERY close attention.",
	"First lets talk ingredients.",
	"Take any two ingredients, and mix 'em together in the mixin bowl!",
	"Be careful what you mix, as you could be creatin horrors...",
	"If you think you've made tomato pasta, put it on the plate and ring the bell!",
	"You've also got a washing machine to wash your ingredients!",
	"But dont wash sponges as they will flood the kitchen.",
	"Your oven here is Falsie! Falsie will cook up any ingredient u throw at her!",
	"However, falsie HATES tomato-based foods apart from a certain pasta sauce, so be careful when feedin her.",
	"Now for emergencies.",
	"It's also important to note that this green light over here will sometimes turn red.",
	"If it does, you've got 5 seconds to press it! I recommend that you do. While it is green, you can do whatever you want.",
	"BUT! The light can also turn a shade of Atomic tangerine - in which case, do NOT press it, just let it be. It's just a safety test light.",
	"You have a recipe book below to see what you've made so far if you get confused, so feel free to check it out!",
	"NOW FOR HOW TO COOK TOMATO PASTA (THE GOAL, REMEMBER?)",
	"For making Pasta with Tomato Sauce, you will need to combine boiling pasta with hot pasta sauce.",
	"How do you get pasta sauce? You must combine caramelised onions and tomato sauce or soup. This is the only way, so lock in.",
	"But how do you get caramelised onions I hear you say?",
	"It involves garlic oil and red onion combining their textures and flavours!",
	"Remember to be careful with garlic oil! as falsie hates oil!",
	"however, oil in other appliances such as the mixing bowl, may go well for you.",
	"The resturant has accidentally supplied bomb blueprints - these have a chance to turn into a real bomb.",
	"In this event, please de-fuse the bomb with the provided instructions.",
	"I ******* love pizza. Even the DCS-Supplied Chicago Town stuff",
	"The supplied dried pasta is very good for makin pizza.",
	"HOWEVER. Do not attempt to create pineapple pizza, otherwise the police will close the restaurant.",
	"Now you might have noticed you have a pufferfish!",
	"By adding it to the washing machine, you can cause it to reanimate from the dead.",
	"I heard rumours of if you combine an alive pufferfish with ice cream you create AI.",
	"In the event of AI creation, it is best to leave it alone completely.",
	"There are many other ways of making life, such as Komodo Dragons!",
	"But I heard they don't make for a very good ingredient...",
	"I don't even know what I'm saying anymore, I'm just really passionate about this restaurant!",
	"I mean come on lil'guy, you are gonna be cooking! Isn't that exciting!",
	"You're in the big leagues now, soon you could be a michelin chef.",
	"There's a few words of wisdom I think you could really use for this task.",
	"'Appear weak when you are strong, and strong when you are weak.'",
	"Sun Tzu said that, did you know that? Let his example be an inspiration to you.",
	"-ALthough then again, he was probably a morally dubious guy, so maybe not.",
	"But hey, what do I know about the Eastern Zhou period of China?",
	"I mean I'm a burger flipper, not a historian. This is what James Archbold is for.",
	"-Sorry, I've got no time to explain! good luck!"
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
		# Start the light timer now that dialogue is complete
		if light:
			light.start_timer()
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
		var wait_time = get_wait_time()
		auto_advance_timer.start(wait_time)
	# otherwise, start typing the current text
	else:
		typing = true
		start_typing(dialogue[current_index])

# used to let the interviewer/player speak
func start_typing(text: String) -> void:
	await get_tree().process_frame  # let UI update first
	# Determine typing speed based on current index
	var typing_delay = get_typing_delay()
	
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
		# Start auto-advance timer after typing finishes (unless it's the last line)
		if current_index < dialogue.size():
			var wait_time = get_wait_time()
			auto_advance_timer.start(wait_time)

func _on_auto_advance_timeout():
	if is_talking and not typing:
		talk()

func get_typing_delay() -> float:
	if current_index > 38:  
		return 0
	elif current_index > 32:  # After "I heard rumours..." - 7x faster
		return 0.00186
	elif current_index > 26:  # After "I **** love pizza." - 4x faster
		return 0.002
	elif current_index > 19:  # After "de-fuse the bomb" - 3x faster
		return 0.0067
	elif current_index > 13:  # After 5th arrow - 2x faster
		return 0.01
	else:
		return 0.02

func get_wait_time() -> float:
	if current_index > 32:  # After "I heard rumours..." - 7x faster
		return 0.143
	elif current_index > 26:  # After "I **** love pizza." - 4x faster
		return 0.25
	elif current_index > 19:  # After "de-fuse the bomb" - 3x faster
		return 0.33
	elif current_index > 13:  # After 5th arrow - 2x faster
		return 0.5
	else:
		return 1.0

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
