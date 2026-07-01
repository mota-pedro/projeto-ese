# obstacle_spawner.gd — Spawna posts positivos e negativos
extends Node2D

@export var post_scene: PackedScene
@export var spawn_interval: float = 1.8
@export var base_speed: float = 280.0

var spawn_timer: float = 0.0
var game_active: bool = true
var elapsed: float = 0.0

# Chance de post positivo começa em 40%
var positive_chance: float = 0.40

func _process(delta):
	if not game_active:
		return

	elapsed += delta
	spawn_timer += delta

	# Aumenta dificuldade ao longo do tempo
	var difficulty_mult = 1.0 + (elapsed / 60.0) * 0.5
	var current_speed = base_speed * difficulty_mult
	var current_interval = max(0.8, spawn_interval / difficulty_mult)

	if spawn_timer >= current_interval:
		spawn_timer = 0.0
		_spawn_post(current_speed)

func _spawn_post(spd: float):
	if not post_scene:
		return

	var post = post_scene.instantiate()
	add_child(post)

	# Altura aleatória na tela
	var screen_h = get_viewport().size.y
	var spawn_y = randf_range(screen_h * 0.2, screen_h * 0.75)
	post.position = Vector2(get_viewport().size.x + 60, spawn_y)

	# Define tipo: positivo ou negativo
	var is_positive = randf() < positive_chance
	post.setup(
		post.PostType.POSITIVE if is_positive else post.PostType.NEGATIVE,
		spd
	)
