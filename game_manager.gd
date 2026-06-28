# game_manager.gd
extends Node

const GAME_DURATION = 180.0  # 3 minutos em segundos

var time_remaining: float = GAME_DURATION
var game_active: bool = false

signal game_over(won: bool)

func _ready():
	start_game()

func start_game():
	time_remaining = GAME_DURATION
	game_active = true

func _process(delta):
	if not game_active:
		return

	time_remaining -= delta

	if time_remaining <= 0:
		time_remaining = 0
		end_game(true)  # jogador sobreviveu!

func player_died():
	end_game(false)

func end_game(won: bool):
	game_active = false
	emit_signal("game_over", won)

func get_formatted_time() -> String:
	var minutes = int(time_remaining) / 60
	var seconds = int(time_remaining) % 60
	return "%02d:%02d" % [minutes, seconds]
