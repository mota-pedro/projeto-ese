extends Control

@onready var recorde_label: Label = $RecordeLabel

func _ready():
	var recorde = SaveGame.recorde_fase
	if recorde <= 0:
		recorde_label.text = "Nenhum recorde ainda"
	else:
		recorde_label.text = "Melhor fase: %d" % recorde

func _on_jogar_pressed():
	GameState.fase_atual = 1
	get_tree().change_scene_to_file("res://primeira_fase.tscn")

func _on_sair_pressed():
	get_tree().quit()
