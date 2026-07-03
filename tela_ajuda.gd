# tela_ajuda.gd — Aba de ajuda do menu principal (também usada como tutorial
# obrigatório na 1ª vez que o jogador clica em "Jogar").
# Mostra as telas de instrução em sequência; clicar na seta avança.
extends Control

@export var telas: Array[Texture2D] = []

@onready var imagem: TextureRect = $Imagem

var indice_atual: int = 0

func _ready():
	indice_atual = 0
	_mostrar_tela_atual()

func _mostrar_tela_atual():
	if telas.is_empty():
		return
	imagem.texture = telas[indice_atual]

func _on_avancar_pressed():
	indice_atual += 1
	if indice_atual >= telas.size():
		_finalizar()
	else:
		_mostrar_tela_atual()

func _finalizar():
	if GameState.veio_do_botao_jogar:
		# Era o tutorial da 1ª vez: marca como visto e já entra na fase.
		GameState.veio_do_botao_jogar = false
		SaveGame.marcar_tutorial_visto()
		get_tree().change_scene_to_file("res://primeira_fase.tscn")
	else:
		# Ajuda acessada pelo menu normalmente: volta pro menu.
		get_tree().change_scene_to_file("res://main_menu.tscn")

func _unhandled_input(event):
	# Permite sair da ajuda a qualquer momento com ESC.
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
