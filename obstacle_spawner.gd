# obstacle_spawner.gd
extends Node2D

@export var post_scene: PackedScene
@export var spawn_interval: float = 1.8
@export var base_speed: float = 280.0

var spawn_timer: float = 0.0
var game_active: bool = true
var elapsed: float = 0.0
var positive_chance: float = 0.40

var camera: Camera2D = null

func _ready():
	await get_tree().process_frame
	# Busca a câmera na cena
	camera = get_tree().get_first_node_in_group("camera")

func _process(delta):
	if not game_active:
		return

	elapsed += delta
	spawn_timer += delta

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
	get_tree().root.add_child(post)

	var screen_w = get_viewport().size.x
	var screen_h = get_viewport().size.y

	var cam_x = camera.global_position.x if camera else 0.0
	var cam_y = camera.global_position.y if camera else 0.0

	var spawn_x = cam_x + (screen_w / 2.0) + 100.0

	# aleatório dentro da tela (ajuste os 0.2 / 0.3 se quiser outra faixa)
	var spawn_y = cam_y + randf_range(-screen_h * 0.3, screen_h * 0.3)

	post.global_position = Vector2(spawn_x, spawn_y)

	# centro da oscilação é a altura de spawn
	post.origin_y = spawn_y

	var is_positive = randf() < positive_chance
	post.setup(
		post.PostType.POSITIVE if is_positive else post.PostType.NEGATIVE,
		spd
	)

func stop():
	game_active = false
