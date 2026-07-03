# tela_transicao.gd
extends Control

@export var duracao: float = 3.0
@export var proxima_cena: String = "res://tela_pausa.tscn"

func _ready():
	await get_tree().create_timer(duracao).timeout
	get_tree().change_scene_to_file(proxima_cena)
