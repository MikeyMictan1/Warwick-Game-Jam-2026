extends Node

var is_in_game: bool = false
var is_paused: bool = false

signal game_state_changed(in_game: bool)
signal pause_state_changed(paused: bool)

func set_in_game(value: bool):
	is_in_game = value
	game_state_changed.emit(is_in_game)

func set_paused(value: bool):
	is_paused = value
	get_tree().paused = value
	pause_state_changed.emit(is_paused)

func toggle_pause():
	if is_in_game:
		set_paused(!is_paused)
