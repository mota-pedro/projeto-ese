extends Node2D

@onready var game_manager = $GameManager
@onready var hud = $HUD
@onready var player = $Player
@onready var spawner = $ObstacleSpawner

var game_finished: bool = false

func _ready():
	# passa a fase atual para o spawner e HUD
	spawner.fase_atual = GameState.fase_atual
	game_manager.game_over.connect(_on_game_over)
	player.health_changed.connect(_on_player_health_changed)
	hud.update_life(player.health, player.max_health)
	hud.update_timer(game_manager.get_formatted_time())
	hud.update_fase(GameState.fase_atual)  # se tiver um label de fase

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

	if spawner:
		spawner.game_active = false

	if won:
		# terminou a fase atual → aumenta uma "fase" e salva recorde
		SaveGame.salvar(GameState.fase_atual)
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://tela_transicao.tscn")  # ou tela_transicao
	else:
		# morreu na fase atual → salva recorde e volta ao menu
		SaveGame.salvar(GameState.fase_atual)
		hud.show_message("Game Over!\nVocê ficou preso no Scroll Loop e\npagou o preço com sua saúde mental.\nO uso excessivo de redes sociais\né prejudicial. Escolha parar.")
		await get_tree().create_timer(8.0).timeout
		get_tree().change_scene_to_file("res://main_menu.tscn")
