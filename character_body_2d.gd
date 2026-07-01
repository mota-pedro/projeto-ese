# character_body_2d.gd — Script do Player
extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)

const GRAVITY: float = 900.0
const JUMP_FORCE: float = -550.0
const MOVE_SPEED: float = 260.0

var max_health: int = 10
var health: int = 10
var is_invincible: bool = false
var invincibility_duration: float = 1.0

func _ready():
	add_to_group("player")

func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0

	# Movimento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * MOVE_SPEED

	# Vira o sprite conforme a direção
	if direction != 0:
		$Sprite2D.flip_h = direction < 0

	# Pulo
	if (Input.is_action_just_pressed("ui_accept") or \
		Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_FORCE

	move_and_slide()

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
	tween.tween_property($Sprite2D, "modulate:a", 0.2, 0.075)
	tween.tween_property($Sprite2D, "modulate:a", 1.0, 0.075)
	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false
	$Sprite2D.modulate.a = 1.0
