# obstacle_spawner.gd
extends Node2D

@export var obstacle_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var obstacle_speed: float = 300.0

var spawn_timer: float = 0.0
var game_active: bool = true

func _process(delta):
	if not game_active:
		return

	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_obstacle()

func spawn_obstacle():
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)

	# Spawna fora da tela à direita
	obstacle.position = Vector2(get_viewport().size.x + 50, 100)
	obstacle.set_speed(obstacle_speed)
