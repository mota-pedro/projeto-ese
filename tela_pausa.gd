# tela_pausa.gd — Tela exibida quando o tempo da fase acaba ("Você fez uma pausa")
extends Control

@export var fase_atual: int = 1
# Cena para a qual o botão "Próxima fase" deve levar.
# Por enquanto só existe a primeira fase, então ele reinicia a mesma fase.
@export var proxima_fase_path: String = "res://primeira_fase.tscn"

@onready var fase_label: Label = $FaseLabel

func _ready():
	fase_label.text = "Fase atual: %d" % fase_atual

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_proxima_fase_pressed():
	get_tree().change_scene_to_file(proxima_fase_path)
