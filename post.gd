# post.gd — Post de rede social: positivo (cura) ou negativo (causa dano)
extends CharacterBody2D

enum PostType { POSITIVE, NEGATIVE }

var post_type: PostType = PostType.NEGATIVE
var speed: float = 280.0

const POSITIVE_SPRITES = [
	preload("res://assets/posts/post_positivo_01.png"),
	preload("res://assets/posts/post_positivo_02.png"),
]

const NEGATIVE_SPRITES = [
	preload("res://assets/posts/post_negativo_01.png"),
	preload("res://assets/posts/post_negativo_02.png"),
]

@onready var hitbox: Area2D = $HitBox
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	if hitbox:
		hitbox.body_entered.connect(_on_body_entered)


func setup(type: PostType, spd: float):
	post_type = type
	speed = spd
	_apply_type()

func _apply_type():
	if post_type == PostType.POSITIVE:
		sprite.texture = POSITIVE_SPRITES[randi() % POSITIVE_SPRITES.size()]
	else:
		sprite.texture = NEGATIVE_SPRITES[randi() % NEGATIVE_SPRITES.size()]

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < -300:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if post_type == PostType.POSITIVE:
			body.heal(2)
		else:
			body.take_damage(2)

		queue_free()
