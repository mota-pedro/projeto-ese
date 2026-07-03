extends Node2D

@export var post_scene: PackedScene
@export var spawn_interval: float = 1.8   # base para fase 1
@export var base_speed: float = 280.0     # base para fase 1

@export var fase_atual: int = 1  # recebe de main.gd

const INTERVALO_MINIMO: float = 0.4
const VELOCIDADE_MAXIMA: float = 650.0

var spawn_timer: float = 0.0
var game_active: bool = true
var elapsed: float = 0.0
var positive_chance: float = 0.40

var camera: Camera2D = null

func _ready():
	await get_tree().process_frame
	camera = get_tree().get_first_node_in_group("camera")
	_aplicar_dificuldade_por_fase()

func _aplicar_dificuldade_por_fase():
	# usa GameState, por segurança
	fase_atual = GameState.fase_atual

	var fator = fase_atual - 1
	base_speed = min(VELOCIDADE_MAXIMA, 280.0 + (fator * 40.0))
	spawn_interval = max(INTERVALO_MINIMO, 1.8 - (fator * 0.15))
	positive_chance = max(0.15, 0.40 - (fator * 0.03))

func _process(delta):
	if not game_active:
		return

	elapsed += delta
	spawn_timer += delta

	# dificuldade cresce com o tempo dentro da mesma “fase”
	var difficulty_mult = 1.0 + (elapsed / 60.0) * 0.5

	var current_speed = min(VELOCIDADE_MAXIMA, base_speed * difficulty_mult)
	var current_interval = max(INTERVALO_MINIMO, spawn_interval / difficulty_mult)

	if spawn_timer >= current_interval:
		spawn_timer = 0.0
		_spawn_post(current_speed)

func _spawn_post(spd: float):
	if not post_scene:
		return

	var post = post_scene.instantiate()
	get_tree().root.add_child(post)

	var screen_w = get_viewport().size.x
	var screen_h = get_viewport().size.y

	var cam_x = camera.global_position.x if camera else 0.0
	var cam_y = camera.global_position.y if camera else 0.0

	var spawn_x = cam_x + (screen_w / 2.0) + 100.0
	var spawn_y = cam_y + randf_range(-screen_h * 0.3, screen_h * 0.3)

	post.global_position = Vector2(spawn_x, spawn_y)
	post.origin_y = spawn_y

	var is_positive = randf() < positive_chance
	post.setup(
		post.PostType.POSITIVE if is_positive else post.PostType.NEGATIVE,
		spd
	)

func stop():
	game_active = false
