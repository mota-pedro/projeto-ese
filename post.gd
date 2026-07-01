# post.gd — Post de rede social: positivo (cura) ou negativo (causa dano)
extends CharacterBody2D

enum PostType { POSITIVE, NEGATIVE }

var post_type: PostType = PostType.NEGATIVE
var speed: float = 280.0
var post_text: String = ""

# Textos negativos — baseados nos estigmas do levantamento
const NEGATIVE_POSTS = [
	"Só os bonitos têm sucesso 😈",
	"Você não é bom o suficiente 💔",
	"Todo mundo está se divertindo menos você 😒",
	"Quantos likes você teve hoje? 🤡",
	"Seu corpo não está no padrão 😬",
	"Ninguém liga para o que você posta 🙄",
	"Você deveria ser mais como ela/ele 😤",
	"Perfeição ou nada! 💀",
	"Olha como todo mundo viajou e você ficou em casa 🏠",
	"Sem likes = sem valor 👎",
]

# Textos positivos — mensagens de apoio à saúde mental
const POSITIVE_POSTS = [
	"Você não precisa ser perfeito 💚",
	"Comparar-se não te faz feliz 🌱",
	"Cuide da sua saúde mental 🧠",
	"Você é suficiente do jeito que é ✨",
	"Pause as redes, respira fundo 🌬️",
	"Likes não definem seu valor 💛",
	"A vida real é mais bonita que o feed 🌻",
	"Peça ajuda quando precisar 🤝",
	"Você tem direito ao equilíbrio digital 📵",
	"Seja gentil com você mesmo hoje 💙",
]

@onready var label: Label = $Label
@onready var hitbox: Area2D = $HitBox
@onready var sprite: ColorRect = $ColorRect

func _ready():
	if hitbox:
		hitbox.body_entered.connect(_on_body_entered)

	_apply_type()

func setup(type: PostType, spd: float):
	post_type = type
	speed = spd

func _apply_type():
	if post_type == PostType.POSITIVE:
		post_text = POSITIVE_POSTS[randi() % POSITIVE_POSTS.size()]
		sprite.color = Color(0.18, 0.72, 0.42, 0.92)   # Verde
	else:
		post_text = NEGATIVE_POSTS[randi() % NEGATIVE_POSTS.size()]
		sprite.color = Color(0.82, 0.15, 0.18, 0.92)   # Vermelho

	label.text = post_text

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < -300:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		var hud = get_tree().get_first_node_in_group("hud")

		if post_type == PostType.POSITIVE:
			body.heal(2)
			if hud:
				hud.show_post_feedback("+" + post_text, true)
		else:
			body.take_damage(2)
			if hud:
				hud.show_post_feedback(post_text, false)

		queue_free()
