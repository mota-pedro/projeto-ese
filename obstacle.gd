# obstacle.gd — mantido para compatibilidade, mas o jogo agora usa post.gd
extends CharacterBody2D

var speed: float = 300.0
@onready var hitbox: Area2D = $HitBox

func _ready():
	if hitbox:
		hitbox.body_entered.connect(_on_body_entered)

func set_speed(s: float):
	speed = s

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < -100:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)
