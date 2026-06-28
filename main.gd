# main.gd
extends Node2D

@onready var game_manager = $GameManager
@onready var hud = $HUD
@onready var player = $Player

var game_finished: bool = false

func _ready():
	game_manager.game_over.connect(_on_game_over)
	player.health_changed.connect(_on_player_health_changed)

	hud.update_life(player.health, player.max_health)
	hud.update_timer(game_manager.get_formatted_time())

func _process(_delta):
	if game_finished:
		return

	hud.update_timer(game_manager.get_formatted_time())

func _on_player_health_changed(current_health: int, max_health: int):
	if game_finished:
		return
	hud.update_life(current_health, max_health)

func _on_game_over(won: bool):
	if game_finished:
		return

	game_finished = true

	if won:
		hud.show_message("Você sobreviveu!")
	else:
		hud.show_message("Game Over!")

	player.set_physics_process(false)
	player.set_process(false)

	if $ObstacleSpawner:
		$ObstacleSpawner.set_process(false)

	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
