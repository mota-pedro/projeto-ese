# damage_number.gd
extends Node2D

@onready var label: Label = $Label

func setup(valor: int, positivo: bool):
	if positivo:
		label.text = "+%d" % valor
		label.modulate = Color(0.2, 1.0, 0.2)  # verde
	else:
		label.text = "-%d" % valor
		label.modulate = Color(1.0, 0.2, 0.2)  # vermelho

	# Animação: sobe e some
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 60, 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(queue_free)
