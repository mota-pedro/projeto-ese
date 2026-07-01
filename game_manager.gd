# game_manager.gd — Gerencia tempo de jogo e condição de vitória/derrota
extends Node

signal game_over(won: bool)

@export var survival_time: float = 60.0  # segundos para vencer

var elapsed_time: float = 0.0
var game_active: bool = true

# Referência ao player para monitorar saúde
var player_ref: Node = null

func _ready():
	# Busca o player na cena
	await get_tree().process_frame
	player_ref = get_tree().get_first_node_in_group("player")
	if player_ref:
		player_ref.health_changed.connect(_on_player_health_changed)

func _process(delta):
	if not game_active:
		return

	elapsed_time += delta

	if elapsed_time >= survival_time:
		game_active = false
		emit_signal("game_over", true)  # Jogador venceu

func _on_player_health_changed(current_health: int, _max_health: int):
	if current_health <= 0 and game_active:
		game_active = false
		emit_signal("game_over", false)  # Game Over

func get_formatted_time() -> String:
	var remaining = max(0.0, survival_time - elapsed_time)
	var mins = int(remaining) / 60
	var secs = int(remaining) % 60
	return "%02d:%02d" % [mins, secs]
