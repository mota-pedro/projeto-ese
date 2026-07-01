# game_manager.gd
extends Node

signal game_over(won: bool)

@export var survival_time: float = 60.0

var elapsed_time: float = 0.0
var game_active: bool = true
var player_ref: Node = null
var spawner_ref: Node = null

func _ready():
	await get_tree().process_frame

	player_ref = get_tree().get_first_node_in_group("player")
	if player_ref:
		player_ref.health_changed.connect(_on_player_health_changed)

	spawner_ref = get_tree().get_first_node_in_group("spawner")

func _process(delta):
	if not game_active:
		return

	elapsed_time += delta

	if elapsed_time >= survival_time:
		_end_game(true)

func _on_player_health_changed(current_health: int, _max_health: int):
	if current_health <= 0 and game_active:
		_end_game(false)

func _end_game(won: bool):
	game_active = false
	# Para o spawner
	if spawner_ref and spawner_ref.has_method("stop"):
		spawner_ref.stop()
	emit_signal("game_over", won)

func get_formatted_time() -> String:
	var remaining = max(0.0, survival_time - elapsed_time)
	var mins = int(remaining) / 60
	var secs = int(remaining) % 60
	return "%02d:%02d" % [mins, secs]
