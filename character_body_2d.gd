extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)

const GRAVITY: float = 1100.0
const JUMP_FORCE: float = -700.0
const MOVE_SPEED: float = 260.0

# --- Tremor de tela quando a saúde mental está baixa ---
const LOW_HEALTH_THRESHOLD: float = 0.5  # abaixo de 50% a tela começa a tremer
const SHAKE_MIN_INTENSITY: float = 1.5   # tremor leve logo abaixo do limite (em pixels)
const SHAKE_MAX_INTENSITY: float = 5.0   # tremor mais forte com a saúde quase zerada
const SHAKE_RECOVER_SPEED: float = 10.0  # velocidade com que a câmera volta ao normal

var max_health: int = 10
var health: int = 10
var is_invincible: bool = false
var invincibility_duration: float = 1.0

var last_direction: String = "right"
var is_crouching: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_normal: CollisionShape2D = $CollisionShape2D
@onready var col_crouch: CollisionShape2D = $CollisionShapeDown
@onready var camera: Camera2D = $Camera2D

func _ready():
	add_to_group("player")
	anim.play("idle_right")
	col_crouch.disabled = true

func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if velocity.y > 0:
			velocity.y = 0.0

	# Movimento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * MOVE_SPEED

	# Aplicar animação + colisão
	_update_state_and_animation(direction)

	# Pulo (só se não estiver agachado)
	if not is_crouching and (Input.is_action_just_pressed("ui_accept") \
		or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_FORCE

	move_and_slide()

	_apply_low_health_shake(delta)

func _update_state_and_animation(direction: float) -> void:
	# Atualiza última direção
	if direction > 0:
		last_direction = "right"
	elif direction < 0:
		last_direction = "left"

	# --- 1) CÁLCULO DE ESTADO ---

	# Quer agachar?
	var wants_to_crouch := is_on_floor() and Input.is_action_pressed("ui_down")

	# Atualiza estado de agachar UMA vez por frame
	if wants_to_crouch and not is_crouching:
		is_crouching = true
		col_normal.disabled = true
		col_crouch.disabled = false
	elif not wants_to_crouch and is_crouching:
		is_crouching = false
		col_normal.disabled = false
		col_crouch.disabled = true

	# --- 2) ESCOLHA DE ANIMAÇÃO (usa só os estados prontos) ---

	# Agachado sempre ganha
	if is_crouching:
		if anim.animation != "crouch":
			anim.play("crouch")
		return

	# No ar
	if not is_on_floor():
		if last_direction == "right":
			if anim.animation != "jump_right":
				anim.play("jump_right")
		else:
			if anim.animation != "jump_left":
				anim.play("jump_left")
		return

	# Em pé no chão
	if direction > 0:
		if anim.animation != "walk_right":
			anim.play("walk_right")
	elif direction < 0:
		if anim.animation != "walk_left":
			anim.play("walk_left")
	else:
		if last_direction == "right":
			if anim.animation != "idle_right":
				anim.play("idle_right")
		else:
			if anim.animation != "idle_left":
				anim.play("idle_left")

func take_damage(amount: int):
	if is_invincible:
		return
	health = max(0, health - amount)
	emit_signal("health_changed", health, max_health)
	_start_invincibility()
	if health <= 0:
		pass

func heal(amount: int):
	health = min(max_health, health + amount)
	emit_signal("health_changed", health, max_health)

func _start_invincibility():
	is_invincible = true
	var tween = create_tween()
	tween.set_loops(int(invincibility_duration / 0.15))
	tween.tween_property(anim, "modulate:a", 0.2, 0.075)
	tween.tween_property(anim, "modulate:a", 1.0, 0.075)
	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false
	anim.modulate.a = 1.0

func _apply_low_health_shake(delta: float):
	if not camera:
		return

	var pct = float(health) / float(max_health)

	if pct <= LOW_HEALTH_THRESHOLD and pct > 0.0:
		# quanto mais perto de 0, mais forte o tremor (mas sempre leve/sutil)
		var t = 1.0 - (pct / LOW_HEALTH_THRESHOLD)
		var intensity = lerp(SHAKE_MIN_INTENSITY, SHAKE_MAX_INTENSITY, t)
		camera.offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
	else:
		# saúde ok (ou zerada/game over): a câmera volta suavemente ao centro
		camera.offset = camera.offset.lerp(Vector2.ZERO, delta * SHAKE_RECOVER_SPEED)
