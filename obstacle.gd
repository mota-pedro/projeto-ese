# obstacle.gd
extends CharacterBody2D

var speed: float = 300.0
@onready var hitbox: Area2D = $HitBox

func _ready():
	if hitbox:
		hitbox.body_entered.connect(_on_body_entered)
	else:
		print("ERRO: HitBox não encontrado!")


func set_speed(s: float):
	speed = s

func _physics_process(delta):
	position.x -= speed * delta

	# Remove o obstáculo quando sair da tela pela esquerda
	if position.x < -100:
		queue_free()

func _on_body_entered(body):
	print("body_entered chamado com: ", body)
	if body.is_in_group("player"):
		print("É player, dando dano")
		body.take_damage(1)
