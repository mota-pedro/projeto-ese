# main_menu.gd
extends Control

func _ready():
	# Garante que o background começa animando
	pass

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://primeira_fase.tscn")

func _on_sair_pressed():
	get_tree().quit()
