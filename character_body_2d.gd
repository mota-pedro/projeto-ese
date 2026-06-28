extends CharacterBody2D

signal health_changed(current_health, max_health)

@export var max_health: int = 3
var health: int = 3

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var cam: Camera2D = $Camera2D
var fixed_y: float

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _ready():
	fixed_y = cam.position.y
	health = max_health
	emit_signal("health_changed", health, max_health)
	

func take_damage(amount: int = 1):
	health -= amount
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health, max_health)

	if health <= 0:
		# aqui você chama o GameManager ou sua lógica de morte
		get_tree().get_root().get_node("Node2D/GameManager").player_died()
