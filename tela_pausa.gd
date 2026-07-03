extends Control

@onready var fase_label: Label = $FaseLabel

func _ready():
	fase_label.text = "Fase atual: %d" % GameState.fase_atual

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_proxima_fase_pressed():
	GameState.fase_atual += 1
	get_tree().change_scene_to_file("res://primeira_fase.tscn")
