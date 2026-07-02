# main.gd — Orquestrador principal da cena
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

	player.set_physics_process(false)
	player.set_process(false)

	if $ObstacleSpawner:
		$ObstacleSpawner.game_active = false

	if won:
		# Tempo da fase acabou: leva para a tela "Você fez uma pausa"
		hud.show_message("🎉 Você sobreviveu!\nSaúde mental protegida!")
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://tela_pausa.tscn")
	else:
		hud.show_message("💔 Game Over!\nCuide da sua mente.")
		await get_tree().create_timer(3.0).timeout
		get_tree().reload_current_scene()
