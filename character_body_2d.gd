extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)

const GRAVITY: float = 1100.0
const JUMP_FORCE: float = -700.0
const MOVE_SPEED: float = 260.0

const LOW_HEALTH_THRESHOLD: float = 0.5
const SHAKE_MIN_INTENSITY: float = 1.5
const SHAKE_MAX_INTENSITY: float = 5.0
const SHAKE_RECOVER_SPEED: float = 10.0

const DAMAGE_NUMBER = preload("res://damage_number.tscn")

var max_health: int = 10
var health: int = 10
var is_invincible: bool = false
var invincibility_duration: float = 1.0

var last_direction: String = "right"
var is_crouching: bool = false

var imunidade_ativa: bool = false
var imunidade_duracao: float = 5.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_normal: CollisionShape2D = $CollisionShape2D
@onready var col_crouch: CollisionShape2D = $CollisionShapeDown
@onready var camera: Camera2D = $Camera2D

func _ready():
	add_to_group("player")
	anim.play("idle_right")
	col_crouch.disabled = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if velocity.y > 0:
			velocity.y = 0.0

	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * MOVE_SPEED

	_update_state_and_animation(direction)

	if not is_crouching and (Input.is_action_just_pressed("ui_accept") \
		or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_FORCE

	move_and_slide()
	_apply_low_health_shake(delta)

func _update_state_and_animation(direction: float) -> void:
	if direction > 0:
		last_direction = "right"
	elif direction < 0:
		last_direction = "left"

	var wants_to_crouch := is_on_floor() and Input.is_action_pressed("ui_down")

	if wants_to_crouch and not is_crouching:
		is_crouching = true
		col_normal.disabled = true
		col_crouch.disabled = false
	elif not wants_to_crouch and is_crouching:
		is_crouching = false
		col_normal.disabled = false
		col_crouch.disabled = true

	if is_crouching:
		if anim.animation != "crouch":
			anim.play("crouch")
		return

	if not is_on_floor():
		if last_direction == "right":
			if anim.animation != "jump_right":
				anim.play("jump_right")
		else:
			if anim.animation != "jump_left":
				anim.play("jump_left")
		return

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
	if is_invincible or imunidade_ativa:  # ← ambos bloqueiam dano
		return
	health = max(0, health - amount)
	emit_signal("health_changed", health, max_health)
	_spawn_feedback(amount, false)
	_start_invincibility()
	if health <= 0:
		pass

func heal(amount: int):
	health = min(max_health, health + amount)
	emit_signal("health_changed", health, max_health)
	_spawn_feedback(amount, true)

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
		var t = 1.0 - (pct / LOW_HEALTH_THRESHOLD)
		var intensity = lerp(SHAKE_MIN_INTENSITY, SHAKE_MAX_INTENSITY, t)
		camera.offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
	else:
		camera.offset = camera.offset.lerp(Vector2.ZERO, delta * SHAKE_RECOVER_SPEED)

func ativar_imunidade():
	if imunidade_ativa:
		return
	imunidade_ativa = true
	
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.mostrar_invisibilidade(true)

	# Transparência da imunidade — não interfere com o piscar do dano
	var tween = create_tween()
	tween.tween_property(anim, "modulate:a", 0.4, 0.3)

	await get_tree().create_timer(imunidade_duracao).timeout

	imunidade_ativa = false
	tween = create_tween()
	tween.tween_property(anim, "modulate:a", 1.0, 0.3)
	
	if is_instance_valid(hud):
		hud.mostrar_invisibilidade(false)
		
func _spawn_feedback(valor: int, positivo: bool):
	var numero = DAMAGE_NUMBER.instantiate()
	get_tree().current_scene.add_child(numero)
	numero.global_position = global_position + Vector2(0, -60)
	numero.setup(valor*10, positivo)
