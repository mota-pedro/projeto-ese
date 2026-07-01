# background.gd
extends Node2D

@export var speed: float = 120.0       # velocidade do fundo
@export var texture: Texture2D        # sua imagem de fundo

@onready var sprite1: Sprite2D = $Sprite2D
@onready var sprite2: Sprite2D = $Sprite2D2

var img_width: float = 0.0

func _ready():
	# Aplica a textura nos dois sprites
	sprite1.texture = texture
	sprite2.texture = texture

	# Centraliza o sprite na posição correta
	sprite1.centered = false
	sprite2.centered = false

	# Pega a largura da imagem
	img_width = texture.get_width()

	# Posiciona lado a lado
	sprite1.position.x = 0
	sprite2.position.x = img_width

func _process(delta):
	# Move os dois para a esquerda
	sprite1.position.x -= speed * delta
	sprite2.position.x -= speed * delta

	# Quando o sprite sai da tela, pula para trás do outro
	var cam_x = get_viewport().get_camera_2d().global_position.x if get_viewport().get_camera_2d() else 0.0
	var left_edge = cam_x - get_viewport().size.x / 2.0

	if sprite1.position.x + img_width < left_edge:
		sprite1.position.x = sprite2.position.x + img_width

	if sprite2.position.x + img_width < left_edge:
		sprite2.position.x = sprite1.position.x + img_width
