extends Node2D


func _ready():
	# Set game state when entering the game scene
	GameManager.set_in_game(true)

func _exit_tree():
	# Reset game state when leaving the game scene
	GameManager.set_in_game(false)
	GameManager.set_paused(false)
