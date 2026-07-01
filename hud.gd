# hud.gd — Interface do usuário: barra de saúde mental, timer e mensagens
extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar
@onready var timer_label: Label = $TimerLabel
@onready var message_label: Label = $MessageLabel
@onready var post_label: Label = $PostLabel  # Mostra o texto do post coletado

func _ready():
	message_label.visible = false
	post_label.visible = false

func update_life(current: int, maximum: int):
	health_bar.max_value = maximum
	health_bar.value = current

	# Muda a cor da barra conforme a saúde
	var fill = health_bar.get_theme_stylebox("fill") as StyleBoxFlat
	if fill:
		var pct = float(current) / float(maximum)
		if pct > 0.6:
			fill.bg_color = Color(0.2, 0.8, 0.4)   # Verde — saudável
		elif pct > 0.3:
			fill.bg_color = Color(1.0, 0.75, 0.0)  # Amarelo — atenção
		else:
			fill.bg_color = Color(0.9, 0.2, 0.2)   # Vermelho — crítico

func update_timer(time_str: String):
	timer_label.text = time_str

func show_message(msg: String):
	message_label.text = msg
	message_label.visible = true

func show_post_feedback(text: String, is_positive: bool):
	post_label.text = text
	post_label.add_theme_color_override("font_color",
		Color(0.2, 0.85, 0.4) if is_positive else Color(0.9, 0.2, 0.2))
	post_label.visible = true

	# Some após 2 segundos
	await get_tree().create_timer(2.0).timeout
	post_label.visible = false
