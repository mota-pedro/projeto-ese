# hud.gd — Interface do usuário: barra de saúde mental, timer e mensagens
extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar
@onready var timer_label: Label = $TimerLabel
@onready var message_label: Label = $MessageLabel
@onready var post_label: Label = $PostLabel  # Mostra o texto do post coletado
@onready var vignette: ColorRect = $Vignette  # Escurece as bordas quando a saúde está baixa
@onready var invisivel_container: HBoxContainer = $InvisivelContainer
@onready var fase_label: Label = $FaseLabel

const LOW_HEALTH_THRESHOLD: float = 0.5   # abaixo de 50% o efeito começa a aparecer
const MAX_VIGNETTE_STRENGTH: float = 0.85 # intensidade máxima (com saúde zerada)

var vignette_tween: Tween

func _ready():
	add_to_group("hud")
	message_label.visible = false
	post_label.visible = false
	invisivel_container.visible=false

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

	_update_vignette(current, maximum)

func _update_vignette(current: int, maximum: int):
	if not vignette or not vignette.material:
		return

	var pct = float(current) / float(maximum)
	var target_strength := 0.0
	if pct <= LOW_HEALTH_THRESHOLD:
		# 0.0 quando pct == 0.5 (limite) até 1.0 quando pct == 0 (saúde zerada)
		var t = 1.0 - (pct / LOW_HEALTH_THRESHOLD)
		target_strength = clamp(t, 0.0, 1.0) * MAX_VIGNETTE_STRENGTH

	var current_strength = vignette.material.get_shader_parameter("strength")
	if vignette_tween:
		vignette_tween.kill()
	vignette_tween = create_tween()
	vignette_tween.tween_method(
		func(v): vignette.material.set_shader_parameter("strength", v),
		current_strength, target_strength, 0.4
	)

func update_timer(time_str: String):
	timer_label.text = time_str

func update_fase(fase: int):
	fase_label.text = "Fase: %d" % fase

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
	
func mostrar_invisibilidade(ativo: bool):
	invisivel_container.visible = ativo
